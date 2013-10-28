//
//  UtilNet.h
//  Network
//
//  Created by MagicStudio on 11-4-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//请求 协议 结构定义
struct struct_requestProtocol 
{
    int bind_receiver;//发送命令与服务端做绑定
    int bind_transmitter;//发送命令与服务端建立通道
    int Unbind;//发送命令与服务端断开连接
    int submit_sm;//发送命令提交数据至服务端
    int Generic_nak;//表示消息有错误的响应
};
struct struct_requestProtocol requestProtocol;

@interface UtilNet : NSObject {
    
}

@end
