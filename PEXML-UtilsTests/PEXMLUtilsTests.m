//
//  PEXMLUtilsTests.m
//
// Copyright (c) 2014-2015 PEXML-Utils
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

#import <KissXML/DDXMLDocument.h>
#import <PEObjc-Commons/PEUtils.h>
#import "PEXMLUtils.h"
#import <Kiwi/Kiwi.h>

SPEC_BEGIN(BACXmlCommonsSpec)

describe(@"BACXmlUtils", ^{
    __block NSString *xmlStr;
    __block NSString *xmlStrWithNs;
    __block DDXMLDocument *xmlDoc;
    __block DDXMLDocument *xmlDocWithNs;
    __block PEXmlUtils *xmlUtils;
    __block PEXmlUtils *xmlUtilsWithNs;

    context(@"all class methods", ^{
        beforeAll(^{
            xmlStr =
              @"<root ra1=\"ra1val\" ra2=\"true\" ra3=\"false\" \
                      da1=\"2015-04-14\" ra4=\"14.7\"> \
                  <ichild>59</ichild> \
                  <child ca1=\"ca1val\">cval</child> \
                  <step-child ba1=\"true\" ba2=\"false\" /> \
                </root>";
            xmlStrWithNs = @"<withns xmlns=\"http://abc.com\" \
                                a1=\"a1-val\">withns-val</withns>";
            xmlDoc = [[DDXMLDocument alloc] initWithXMLString:xmlStr
                                                      options:0
                                                        error:nil];
            xmlDocWithNs = [[DDXMLDocument alloc] initWithXMLString:xmlStrWithNs
                                                            options:0
                                                              error:nil];
            xmlUtils = [[PEXmlUtils alloc] initWithDocument:xmlDoc];
            xmlUtilsWithNs = [[PEXmlUtils alloc]
                                 initWithDocument:xmlDocWithNs
                                 prefixForDefaultNs:@"v"];
          });

        context(@"dateAttrExtractorWithPattern:", ^{
            it(@"works with sane inputs", ^{
                NSObject *rootNode =
                  [[xmlUtils nodesForXPath:@"/root"] objectAtIndex:0];
                xmlUtils = [[PEXmlUtils alloc]
                               initWithNode:(DDXMLNode *)rootNode];
                DateAttrExtractorBlk dateAttrEx =
                  [xmlUtils dateAttrExtractorWithPattern:@"yyyy-MM-dd"];
                // non-existent attribute
                [dateAttrEx(@"rz0") shouldBeNil];
                // this attribute exists
                [[dateAttrEx(@"da1") should]
                  equal:[PEUtils dateFromString:@"2015-04-14"
                                    withPattern:@"yyyy-MM-dd"]];
              });
          });

        context(@"dateAttrExtractorForElementAtXPath:withPattern:", ^{
            it(@"works with sane inputs", ^{
                DateAttrExtractorBlk dateAttrEx =
                  [xmlUtils dateAttrExtractorForElementAtXPath:@"/root"
                                                     withPattern:@"yyyy-MM-dd"];
                // non-existent attribute
                [dateAttrEx(@"rz0") shouldBeNil];
                // this attribute exists
                [[dateAttrEx(@"da1") should]
                  equal:[PEUtils dateFromString:@"2015-04-14"
                                    withPattern:@"yyyy-MM-dd"]];
              });
          });

        context(@"decAttrExtractor", ^{
            it(@"works with sane inputs", ^{
                NSObject *rootNode =
                  [[xmlUtils nodesForXPath:@"/root"] objectAtIndex:0];
                xmlUtils = [[PEXmlUtils alloc]
                               initWithNode:(DDXMLNode *)rootNode];
                DecAttrExtractorBlk decAttrEx = [xmlUtils decAttrExtractor];
                // non-existent attribute
                [decAttrEx(@"rz0") shouldBeNil];
                // this attribute exists
                [[decAttrEx(@"ra4") should]
                  equal:[NSDecimalNumber decimalNumberWithString:@"14.7"]];
              });
          });

        context(@"decAttrExtractorForElementAtXPath:", ^{
            it(@"works with sane inputs", ^{
                DecAttrExtractorBlk decAttrEx =
                  [xmlUtils decAttrExtractorForElementAtXPath:@"/root"];
                // non-existent attribute
                [decAttrEx(@"rz0") shouldBeNil];
                // this attribute exists
                [[decAttrEx(@"ra4") should]
                  equal:[NSDecimalNumber decimalNumberWithString:@"14.7"]];
              });
          });

        context(@"strAttrExtractor", ^{
            it(@"works with sane inputs", ^{
                NSObject *rootNode =
                  [[xmlUtils nodesForXPath:@"/root"] objectAtIndex:0];
                xmlUtils = [[PEXmlUtils alloc]
                               initWithNode:(DDXMLNode *)rootNode];
                StrAttrExtractorBlk strAttrEx = [xmlUtils strAttrExtractor];
                // non-existent attribute
                [strAttrEx(@"rz0") shouldBeNil];
                // these attributes exist
                [[strAttrEx(@"ra2") should] equal:@"true"];
                [[strAttrEx(@"ra1") should] equal:@"ra1val"];
              });
          });

        context(@"strAttrExtractorForElementAtXPath:", ^{
            it(@"works with sane inputs", ^{
                StrAttrExtractorBlk strAttrEx =
                  [xmlUtils strAttrExtractorForElementAtXPath:@"/root"];
                // non-existent attribute
                [strAttrEx(@"rz0") shouldBeNil];
                // these attributes exist
                [[strAttrEx(@"ra2") should] equal:@"true"];
                [[strAttrEx(@"ra1") should] equal:@"ra1val"];
              });
          });

        context(@"boolAttrExtractor", ^{
            it(@"works with sane inputs", ^{
                NSObject *rootNode =
                  [[xmlUtils nodesForXPath:@"/root"] objectAtIndex:0];
                xmlUtils = [[PEXmlUtils alloc]
                               initWithNode:(DDXMLNode *)rootNode];
                BoolAttrExtractorBlk boolAttrEx = [xmlUtils boolAttrExtractor];
                // non-existent attribute
                [[theValue(boolAttrEx(@"ra0")) should] beNo];
                // these attributes exist
                [[theValue(boolAttrEx(@"ra2")) should] beYes];
                [[theValue(boolAttrEx(@"ra3")) should] beNo];
              });
          });

        context(@"boolAttrExtractorForElementAtXPath:", ^{
            it(@"works with sane inputs", ^{
                BoolAttrExtractorBlk boolAttrEx =
                  [xmlUtils boolAttrExtractorForElementAtXPath:@"/root"];
                // non-existent attribute
                [[theValue(boolAttrEx(@"ra0")) should] beNo];
                // these attributes exist
                [[theValue(boolAttrEx(@"ra2")) should] beYes];
                [[theValue(boolAttrEx(@"ra3")) should] beNo];
              });
          });

        context(@"xpathForAttribute:elementXPath:", ^{
            it(@"works with sane inputs", ^{
                NSString *expr =
                  [PEXmlUtils xpathForAttribute:@"color"
                                      elementXPath:@"/trucks/truck[0]"];
                [[expr should] equal:@"/trucks/truck[0]/@color"];
                expr = [PEXmlUtils xpathForAttribute:@"color"
                                           elementXPath:nil];
                [[expr should] equal:@"@color"];
              });
          });

        context(@"valueForXPath:forNode:", ^{
            it(@"works when the xpath expression describes a non-nil value", ^{
                [[[xmlUtils valueForXPath:@"/root/child"] should]
                  equal:@"cval"];
                [[[xmlUtils valueForXPath:@"/root/@ra1"] should]
                  equal:@"ra1val"];
                [[[xmlUtils valueForXPath:@"/root/child/@ca1"] should]
                  equal:@"ca1val"];

                // namespace-uri version
                [[[xmlUtilsWithNs valueForXPath:@"/v:withns/@a1"] should]
                  equal:@"a1-val"];
              });

            it(@"works as expected when the given XML document is nil", ^{
                [[[[PEXmlUtils alloc] initWithDocument:nil]
                   valueForXPath:@"/root/@ra1"] shouldBeNil];
              });
          });

        context(@"xsdBoolStrToBool:", ^{
            it(@"works as expected", ^{
                [[theValue([PEXmlUtils xsdBoolStrToBool:@"true"]) should]
                  equal:theValue(YES)];
                [[theValue([PEXmlUtils xsdBoolStrToBool:@"false"]) should]
                  equal:theValue(NO)];
                [[theValue([PEXmlUtils xsdBoolStrToBool:@"YES"]) should]
                  equal:theValue(YES)];
                [[theValue([PEXmlUtils xsdBoolStrToBool:@"falze"]) should]
                  equal:theValue(NO)];
                [[theValue([PEXmlUtils xsdBoolStrToBool:@"abc123"]) should]
                  equal:theValue(NO)];
                [[theValue([PEXmlUtils xsdBoolStrToBool:@"t"]) should]
                  equal:theValue(YES)];
              });
          });

        context(@"boolValueForXPath:forNode:", ^{
            it(@"works as expected with sane inputs", ^{
                [[theValue([xmlUtils boolValueForXPath:@"/root/child"])
                          should] equal:theValue(NO)];
                [[theValue([xmlUtils
                             boolValueForXPath:@"/root/step-child/@ba1"])
                          should] equal:theValue(YES)];
                [[theValue([xmlUtils
                             boolValueForXPath:@"/root/step-child/@ba2"])
                          should] equal:theValue(NO)];
              });

            it(@"works as expected with sane nils", ^{
                [[theValue([[[PEXmlUtils alloc] initWithDocument:nil]
                             boolValueForXPath:@"/root/child"]) should]
                  equal:theValue(NO)];
                [[theValue([xmlUtils boolValueForXPath:@"/root/mother"])
                          should] equal:theValue(NO)];
              });
          });

        context(@"intValueForXPath:forNode:", ^{
            it(@"works as expected with sane inputs", ^{
                [[theValue([xmlUtils intValueForXPath:@"/root/ichild"])
                          should] equal:theValue(59)];
              });

            it(@"works as expected with sane nils", ^{
                [[theValue([xmlUtils intValueForXPath:@"/root/nochild"])
                     should] equal:theValue(0)];
              });
          });
      });
  });

SPEC_END
