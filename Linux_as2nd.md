2025-5-20 前夜

几天没留神, 微软愈发地贱了 -- 这个天天想给用户当爹的公司, 最近在PC机的双系统启动上又搞了更多的小动作.

下面就是怎样在Windows上安装Linux (以当下最新版的 ThinkPad - Manjaro 为例):

### 准备工作:
1. 禁用Windows的BitLocker
2. 进入BIOS设置(\[Enter\] F1):
   - 将Secure Boot设置为Disabled
   - 设置BIOS模式为UEFI (而不是Legacy; 当下新机默认就是UEFI)
   - Controller Mode选择AHCI(而不是Intel RST; 当下版本, 无此选项, 不需设置)
3. 下载Manjaro和Rufus
4. 准备好优盘

备注: 关于如何进入BIOS设置, 当下Thinkpad的BIOS中有Boot Mode选项:
- 默认为Quick(快速启动), 这种模式下, 要进入BIOS设置, 需先按Enter然后再按F1
- 还有一种Diagnose(诊断启动), 这种模式下, 开机自检时按F1就可以直接进入BIOS(和30年前的老PC一样)

### 
