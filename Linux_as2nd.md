几天没留神, 微软愈发地贱了 -- 这个天天想给用户当爹的公司, 最近在PC机的双系统启动上又搞了更多的小动作.

下面就是怎样在Windows上安装Linux (以ThinkPad为例):

### 准备工作:
1. 禁用Windows的BitLocker
2. 进入BIOS设置(\[Enter\] F1)，将Secure Boot设置为Disabled
3. 在Windows的`msinfo32`中, 确认BIOS模式为UEFI (若是Legacy, 则需在BIOS修改)
4. 在BIOS中, 关闭Intel RST
