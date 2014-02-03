# MKPolygon Boolean Operator Category

## About MKPolygon-GPC

MKPolygon-GPC is an Objective-C Category that adds polygon boolean operators to the MKPolygon class.

## Installing
### CocoaPods
The easiest way to install MKPolygon-GPC is using CocoaPods:

1) Add the pod to podfile 
```
pod 'MKPolygon-GPC', '~> 0.0.1'
```

2) Refresh your project pods ```pod install```

### Manually
If you're not using cocoapods, just add `MKPolygon+GPC.h`, `MKPolygon+GPC.m`, `gpc.h` & `gpc.c` in your XCode project.

## Usage

Usage is really simple. Just import the `MKPolygon+GPC.h` header file into your code.

```
#import "MKPolygon+GPC.h"

MKPolygon * firstPolygon = [code to create your 1st polygon];
MKPolygon * secondPolygon = [code to create your 2nd polygon];

// Create the union of two polygons.
MKPolygon * unionPolygon = [firstPolygon polygonFromUnionWithPolygon:secondPolygon];

// Create the difference between two polygons.
MKPolygon * differencePolygon = [firstPolygon polygonFromDifferenceWithPolygon:secondPolygon];

// Create the intersection between two polygons.
MKPolygon * intersectionPolygon = [firstPolygon polygonFromIntersectionWithPolygon:secondPolygon];

// Create the XOR between two polygons.
MKPolygon * exclusiveOrPolygon = [firstPolygon polygonFromExclusiveOrWithPolygon:secondPolygon];
```

## Release Notes

For change logs and release notes, see the [changelog](CHANGELOG.md) file.

## Credits

MKPolygon-GPC makes use of [General Polygon Clipper library (GPC)](http://www.cs.man.ac.uk/~toby/gpc/). Please see the [GPC License Arrangements](MKPolygon-GPC-Example/MKPolygon-GPC/gpc232/GPC-README.pdf) PDF and contact [Toby Howard](mailto:toby.howard@manchester.ac.uk?Subject=GPC Enquiry \(MKPolygon-GPC\)) for details.

## MIT License

Copyright © 2014 SunGard

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## GPC Licensing

GPC is free for downloading and time-unlimited evaluation by anyone.

Non-commercial use of GPC (for example: private / hobbyist / education)
GPC is free for non-commercial use only.

Commercial use of GPC (for example: product development / commercial research)
If you wish to use GPC in support of a commercial product, you must obtain an official GPC Commercial Use License from The University of Manchester.

Please see the [GPC License Arrangements](MKPolygon-GPC-Example/MKPolygon-GPC/gpc232/GPC-README.pdf) PDF and contact [Toby Howard](mailto:toby.howard@manchester.ac.uk?Subject=GPC Enquiry \(MKPolygon-GPC\)) for details.