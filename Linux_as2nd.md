2025-5-20 前夜

几天没留神, 那个天天想给用户当爹的微软, 最近在PC机的双系统启动上, 贱呲呲地又搞了更多的小动作.

下面就是怎样Fuck他, 实现Windows / Linux双系统启动 (以当下新版的 ThinkPad - Manjaro 为例):

### 1. 前期设置(重要提醒: 依次进行):
1. 禁用Windows的BitLocker
2. 进入BIOS设置(\[Enter\] F1):
   1) 设置BIOS模式为UEFI (而不是Legacy; 当下新机默认就是UEFI, 不再兼任传统选项)
   2) 将Secure Boot设置为Disabled(重要! 安装前必须)
   3) 在Secure Boot相关设置中, 打开Allow Microsoft 3rd party UEFI CA
   4) Controller Mode选择AHCI(而不是Intel RST; 当下版本, 无此选项, 不需设置)

Note: 关于如何进入BIOS设置, 当下Thinkpad的BIOS中有Boot Mode选项:
- 默认为Quick(快速启动), 这种模式下, 要进入BIOS设置, 需先按Enter然后再按F1
- 还有一种Diagnose(诊断启动), 这种模式下, 开机自检时按F1就可以直接进入BIOS(和30年前的老PC一样)

### 2. 媒介准备
1. 在Windows任务栏Start Flag上, 右击鼠标, 选择`磁盘管理`, 打开磁盘管理器
2. 调整硬盘分区, 留出足够大的空间给Linux
   - 新机默认C/D两个盘, 可以把C留给Win, 把D给Linux就好, 这样就不用调整了;
   - 为了避免后面安装Linux时选错, 可以考虑给D换个文件系统
3. 下载Manjaro镜像和Rufus备用
4. 准备好优盘, 并使用Rufus将Manjaro镜像写入其中

### 3. 安装工作
- 最主要的就是, 在`选择存储器`时, 使用`取代一个分区`的方式, 而不是默认的`抹除磁盘`(后者会将整个磁盘全部擦除!)
- 选择`取代一个分区`后, 还需要仔细地`选择要安装到的分区`(应对应Windows中的D盘; 可根据前面格式化的文件系统类型, 并参考分区的前后位置确定)
- 关于文件系统的选择, Manjaro居然默认选btrfs了! 不确定是否够稳定, 自己手动选了ext4 (事实上, 第二选择也是xfs, 而非btrfs)
- 其他的, 按照提示, 照实选择即可

### 4. 后续工作
安装Manjaro后会发现, 即使是朴素的xfce, 现在的界面也可以谈优雅和审美了.
然而, 这里还有一系列的后续工作要做, 最主要的就是:
1. 换源 `sudo pacman-mirrors --fasttrack`
2. 更新 `sudo pacman -Syu`
3. 在 Pacman 软件包管理器中, 启用对 Snap 和 Flatpak 的支持
4. 启用 TRIM (4SSD) `sudo systemctl enable fstrim.timer`
