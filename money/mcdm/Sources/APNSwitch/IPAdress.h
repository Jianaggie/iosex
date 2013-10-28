//
//  IPAdress.h
//  unuion03
//
//  Created by easystudio on 2/17/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#include <sys/cdefs.h>

#define MAXADDRS    32    
extern char *if_names[MAXADDRS];  
extern char *ip_names[MAXADDRS]; 
extern char *hw_addrs[MAXADDRS];  
extern unsigned long ip_addrs[MAXADDRS];    
// Function prototypes    
__BEGIN_DECLS
//extern "C" {
void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();
__END_DECLS
//}
