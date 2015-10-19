#import "SRAHAcknowledgementsListController.h"

@implementation SRAHAcknowledgementsListController

-(NSString *)chatheadsLicense {
	return [NSString stringWithFormat:@"Copyright (c) 2013, Matthias Hochgatterer <matthias.hochgatterer@gmail.com>\n\n"
										@"Permission to use, copy, modify, and/or distribute this software for any\n"
										@"purpose with or without fee is hereby granted, provided that the above\n"
										@"copyright notice and this permission notice appear in all copies.\n\n"
										@"THE SOFTWARE IS PROVIDED \"AS IS\" AND THE AUTHOR DISCLAIMS ALL WARRANTIES\n"
										@"WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF\n"
										@"MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR\n"
										@"ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES\n"
										@"WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN\n"
										@"ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF\n"
										@"OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE."];
}

-(NSString *)colorpickerLicense {
	return [NSString stringWithFormat:@"The MIT License (MIT)\n\n"
									@"Copyright (C) 2014 Carlos Vidal\n\n"
									@"Permission is hereby granted, free of charge,\n"
									@"to any person obtaining a copy of this software and associated documentation files (the \"Software\"),\n" 
									@"to deal in the Software without restriction, including without limitation the rights to \n"
									@"use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,\n"
									@"and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n"
									@"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n"
									@"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,\n"
									@"INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n"
									@"IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,\n"
									@"WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN\n"
									@"CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE LICENSE"];
}

-(NSString *)reachabilityLicense {
	return [NSString stringWithFormat:@"Copyright (c) 2011-2013, Tony Million.\n\n"
										@"All rights reserved.\n"
										@"Redistribution and use in source and binary forms, with or without\n"
										@"modification, are permitted provided that the following conditions are met:\n\n"
										@"1. Redistributions of source code must retain the above copyright notice, this\n"
										@"list of conditions and the following disclaimer.\n\n"
										@"2. Redistributions in binary form must reproduce the above copyright notice,\n"
										@"this list of conditions and the following disclaimer in the documentation\n"
										@"and/or other materials provided with the distribution.\n\n"
										@"THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"\n"
										@"AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE\n"
										@"IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE\n"
										@"ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE\n"
										@"LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR\n"
										@"CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF\n"
										@"SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS\n"
										@"INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN\n"
										@"CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)\n"
										@"ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE\n"
										@"POSSIBILITY OF SUCH DAMAGE."];
}

-(NSString *)progresHudLicense {
	return [NSString stringWithFormat:@"Copyright (c) 2013 Matej Bukovinski\n\n"
									@"Permission is hereby granted, free of charge,\n"
									@"to any person obtaining a copy of this software and associated documentation files (the \"Software\"),\n" 
									@"to deal in the Software without restriction, including without limitation the rights to \n"
									@"use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,\n"
									@"and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\n"
									@"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n"
									@"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,\n"
									@"INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n"
									@"IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,\n"
									@"WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN\n"
									@"CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."];
}

-(void)openGithubURLForSpecifier:(PSSpecifier *)specifier {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[specifier propertyForKey:@"linkURL"]]];
}

- (id)specifiers {
	if(_specifiers == nil) {
		NSMutableArray *specs = [NSMutableArray array];
		PSSpecifier *descriptiveSpec = [PSSpecifier groupSpecifierWithName:@"This Tweak (AppHeads) uses the following third-party libraries:"];
		[specs addObject:descriptiveSpec];
		PSSpecifier *chatheadsHeader = [PSSpecifier groupSpecifierWithName:@"ChatHeads"];
		[chatheadsHeader setProperty:[self chatheadsLicense] forKey:@"footerText"];
		[specs addObject:chatheadsHeader];
		PSSpecifier *chatheadSpec = [PSSpecifier preferenceSpecifierNamed:@"ChatHeads on Github" target:self set:nil get:nil detail:nil cell:[PSTableCell cellTypeFromString:@"PSButtonCell"] edit:nil];
		[chatheadSpec setProperty:@"https://github.com/brutella/chatheads" forKey:@"linkURL"];
		SEL *action = &MSHookIvar<SEL>(chatheadSpec,"action");
		*action = @selector(openGithubURLForSpecifier:);
		[specs addObject:chatheadSpec];
		PSSpecifier *colorpickerHeader = [PSSpecifier groupSpecifierWithName:@"NKOColorPickerView"];
		[colorpickerHeader setProperty:[self colorpickerLicense] forKey:@"footerText"];
		[specs addObject:colorpickerHeader];
		PSSpecifier *colorPickerGithub = [PSSpecifier preferenceSpecifierNamed:@"NKOColorPickerView on Github" target:self set:nil get:nil detail:nil cell:[PSTableCell cellTypeFromString:@"PSButtonCell"] edit:nil];
		[colorPickerGithub setProperty:@"https://github.com/FWCarlos/NKO-Color-Picker-View-iOS" forKey:@"linkURL"];
		SEL *colorAction = &MSHookIvar<SEL>(colorPickerGithub,"action");
		*colorAction = @selector(openGithubURLForSpecifier:);
		[specs addObject:colorPickerGithub];
		PSSpecifier *reachabilityHeader = [PSSpecifier groupSpecifierWithName:@"Reachability"];
		[reachabilityHeader setProperty:[self reachabilityLicense] forKey:@"footerText"];
		[specs addObject:reachabilityHeader];
		PSSpecifier *reachabilityGithub = [PSSpecifier preferenceSpecifierNamed:@"Reachability on Github" target:self set:nil get:nil detail:nil cell:[PSTableCell cellTypeFromString:@"PSButtonCell"] edit:nil];
		[reachabilityGithub setProperty:@"https://github.com/tonymillion/Reachability" forKey:@"linkURL"];
		SEL *reachabilityAction = &MSHookIvar<SEL>(reachabilityGithub,"action");
		*reachabilityAction = @selector(openGithubURLForSpecifier:);
		[specs addObject:reachabilityGithub];
		PSSpecifier *progressHudHeader = [PSSpecifier groupSpecifierWithName:@"MBProgressHUD"];
		[progressHudHeader setProperty:[self progresHudLicense] forKey:@"footerText"];
		[specs addObject:progressHudHeader];
		PSSpecifier *progresHudGithub = [PSSpecifier preferenceSpecifierNamed:@"MBProgressHUD on Github" target:self set:nil get:nil detail:nil cell:[PSTableCell cellTypeFromString:@"PSButtonCell"] edit:nil];
		[progresHudGithub setProperty:@"https://github.com/tonymillion/Reachability" forKey:@"linkURL"];
		SEL *progressHudAction = &MSHookIvar<SEL>(progresHudGithub,"action");
		*progressHudAction = @selector(openGithubURLForSpecifier:);
		[specs addObject:progresHudGithub];
		_specifiers = (NSArray *)[specs copy];
	}
	return _specifiers;
}

@end