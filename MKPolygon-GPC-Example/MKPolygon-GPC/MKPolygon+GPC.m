//
// MKPolygon+GPC.m
//
// Created by Justin Leger on 1/21/14.
// Copyright (c) 2014 SunGard Consulting Services
// 		  ___           ___           ___
// 		 /  /\         /  /\         /  /\
// 		/  /::\       /  /::\       /  /::\
// 	   /__/:/\:\     /  /:/\:\     /__/:/\:\
// 	  _\_ \:\ \:\   /  /:/  \:\   _\_ \:\ \:\
// 	 /__/\ \:\ \:\ /__/:/ \  \:\ /__/\ \:\ \:\
// 	 \  \:\ \:\_\/ \  \:\  \__\/ \  \:\ \:\_\/
// 	  \  \:\_\:\    \  \:\        \  \:\_\:\
// 	   \  \:\/:/     \  \:\        \  \:\/:/
// 		\  \::/       \  \:\        \  \::/
// 		 \__\/         \__\/         \__\/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MKPolygon+GPC.h"
#import "gpc.h"


@interface MKPolygon (Private)

+ (MKPolygon *) polygonWithGPCPolygon:(gpc_polygon *) gpcPolygon interiorPolygons:(NSArray *)interiorPolygons;

- (gpc_polygon *) createGPCPolygon;
- (MKPolygon *) polygonWithPolygon:(MKPolygon *) otherPolygon usingBooleanOperation:(gpc_op) op;

@end


@implementation MKPolygon (GPC)

+ (MKPolygon *) polygonWithGPCPolygon:(gpc_polygon *) gpcPolygon interiorPolygons:(NSArray *)interiorPolygons
{
	NSAssert( gpcPolygon != NULL, @"attempt to create path from NULL gpcPolygon");
	
	NSUInteger vertCount = gpcPolygon->contour[0].num_vertices;
	
	if (vertCount == 0) return nil;
	
	MKMapPoint mapPoints[vertCount];
	NSUInteger pCount;
	
	for( pCount = 0; pCount < vertCount; ++pCount )
	{
		mapPoints[pCount].x = gpcPolygon->contour[0].vertex[pCount].x;
		mapPoints[pCount].y = gpcPolygon->contour[0].vertex[pCount].y;
	}
	
	if (interiorPolygons && [interiorPolygons count] > 0) {
		return [MKPolygon polygonWithPoints:mapPoints count:pCount interiorPolygons:interiorPolygons];
	} else {
		return [MKPolygon polygonWithPoints:mapPoints count:pCount];
	}
}

- (gpc_polygon *) createGPCPolygon
{
	NSUInteger pCount = [self pointCount];
	if (pCount == 0) return NULL;
	
	gpc_polygon * gpcPolygon;
	
	// allocate memory for the gpcPolygon.
	
	gpcPolygon = (gpc_polygon *) malloc( sizeof( gpc_polygon ));
	
	if ( gpcPolygon == NULL ) return NULL;
	
	gpcPolygon->contour = NULL;
	gpcPolygon->hole = NULL;
	
	// how many contours do we need?
	
	gpcPolygon->num_contours = 1;
	
	gpcPolygon->contour = (gpc_vertex_list *) malloc( sizeof( gpc_vertex_list ) * 1 );
	
	if ( gpcPolygon->contour == NULL ) {
		gpc_free_polygon( gpcPolygon );
		return NULL;
	}
	
	// allocate enough memory to hold this many points
	
	gpcPolygon->contour[0].num_vertices = (int) pCount;
	gpcPolygon->contour[0].vertex = (gpc_vertex *) malloc( sizeof( gpc_vertex ) * pCount );
	
	for( NSInteger idx = 0; idx < pCount; ++idx )
	{
		gpcPolygon->contour[0].vertex[idx].x = self.points[idx].x;
		gpcPolygon->contour[0].vertex[idx].y = self.points[idx].y;
	}
	
	return gpcPolygon;
}

- (MKPolygon *) polygonWithPolygon:(MKPolygon *) otherPolygon usingBooleanOperation:(gpc_op) op
{
	gpc_polygon	*a, *b, *c;
	
	a = [self createGPCPolygon];
	b = [otherPolygon createGPCPolygon];
	
	if ( a == NULL || b == NULL )
	{
		if( a != NULL ) {
			gpc_free_polygon( a );
			return self;
		}
		
		if( b != NULL ) {
			gpc_free_polygon( b );
			return otherPolygon;
		}
	}
	
	// allocate memory for the gpcPolygon
	
	c = (gpc_polygon *) malloc( sizeof( gpc_polygon ));
	
	// perform the clipping boolean operation
	
	gpc_polygon_clip( op, a, b, c );
	
	// Combine the two internal polygon arrays if they exist.
	
	NSMutableArray * interiorPolygonsCombined = [NSMutableArray new];
	
	if (self.interiorPolygons && [self.interiorPolygons count] > 0)
		[interiorPolygonsCombined addObjectsFromArray:self.interiorPolygons];
	
	if (otherPolygon.interiorPolygons && [otherPolygon.interiorPolygons count] > 0)
		[interiorPolygonsCombined addObjectsFromArray:otherPolygon.interiorPolygons];
	
	// Make a MKPolygon from a GPC polygon
	
	MKPolygon * newPolygon = [MKPolygon polygonWithGPCPolygon:c interiorPolygons:interiorPolygonsCombined];
	
	gpc_free_polygon( a );
	gpc_free_polygon( b );
	gpc_free_polygon( c );
	
	return newPolygon;
}

- (MKPolygon *) polygonFromUnionWithPolygon:(MKPolygon *) otherPolygon
{
	// TODO : Need checks for intersection
	// If rects do not intersect then append polygons together
	// If they do intersect then perfom union else append
	
	MKPolygon * newPolygon = [self polygonWithPolygon:otherPolygon usingBooleanOperation:GPC_UNION];
	
	return newPolygon;
}

- (MKPolygon *) polygonFromIntersectionWithPolygon:(MKPolygon *) otherPolygon
{
	// TODO : Need checks for intersection
	// If rects do not intersect then return nil
	
	MKPolygon * newPolygon = [self polygonWithPolygon:otherPolygon usingBooleanOperation:GPC_INT];
	
	return newPolygon;
}

- (MKPolygon *) polygonFromDifferenceWithPolygon:(MKPolygon *) otherPolygon
{
	// TODO : Need checks for intersection
	// If rects do not intersect then return self
	
	MKPolygon * newPolygon = [self polygonWithPolygon:otherPolygon usingBooleanOperation:GPC_DIFF];
	
	return newPolygon;
}

- (MKPolygon *) polygonFromExclusiveOrWithPolygon:(MKPolygon *) otherPolygon
{
	// TODO : Need checks for intersection
	// If rects do not intersect then append polygons together
	
	MKPolygon * newPolygon = [self polygonWithPolygon:otherPolygon usingBooleanOperation:GPC_XOR];
	
	return newPolygon;
}


@end
