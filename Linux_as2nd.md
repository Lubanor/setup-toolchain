2025-5-20 前夜

几天没留神, 那个天天想给用户当爹的微软, 最近在PC机的双系统启动上, 贱呲呲地又搞了更多的小动作.

下面就是怎样Fuck他, 实现Windows / Linux双系统启动 (以当下新版的 ThinkPad - Manjaro 为例):

### 准备工作(重要提醒: 依次进行):
1. 禁用Windows的BitLocker
2. 进入BIOS设置(\[Enter\] F1):
   1) 设置BIOS模式为UEFI (而不是Legacy; 当下新机默认就是UEFI, 不再兼任传统选项)
   2) 将Secure Boot设置为Disabled(重要! 安装前必须)
   3) 在Secure Boot相关设置中, 打开Allow Microsoft 3rd party UEFI CA
   4) Controller Mode选择AHCI(而不是Intel RST; 当下版本, 无此选项, 不需设置)
3. 下载Manjaro和Rufus备用
4. 准备好优盘

Note: 关于如何进入BIOS设置, 当下Thinkpad的BIOS中有Boot Mode选项:
- 默认为Quick(快速启动), 这种模式下, 要进入BIOS设置, 需先按Enter然后再按F1
- 还有一种Diagnose(诊断启动), 这种模式下, 开机自检时按F1就可以直接进入BIOS(和30年前的老PC一样)

### 
