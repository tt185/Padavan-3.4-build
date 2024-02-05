#####################################################################
# cd /opt/rt-n56u/trunk 执行在这个目录下
#
# 修改默认参数（不同设备拷贝到相应 *.sh)
#####################################################################

user_name="admin"                             # 用户名
user_password="admin"                         # 登录密码
lan_ip="192.168.2"                            # LAN 地址 别写后面的 .1
wlan_2g_ssid="asus"                           # 2G 无线名称
wlan_5g_ssid="asus_5G"                        # 5G 无线名称
wlan_guest_2g_ssid="asus_Guset"               # 2G 访客无线名称
wlan_guest_5g_ssid="asus_Guest_5G"            # 5G 访客无线名称
wlan_2g_psk="66668888"                        # 2G WIFI密码最少8位 空白为不设置
wlan_5g_psk="66668888"                        # 5G WIFI密码最少8位 空白为不设置
version_time=$(date +%Y%m%d)                  # 更新时版本号时间: 20210101
default_file="./user/shared/defaults.h"       # 默认配置文件
config="./configs/templates/YK-L1.config"     # 默认配置文件

#echo "输出修改前的config文件内容"
#cat $config

echo "修改用户名"
sed -i 's/SYS_USER_ROOT		"admin"/SYS_USER_ROOT		"'$user_name'"/g' $default_file

echo "修改登陆密码"
sed -i 's/DEF_ROOT_PASSWORD	"admin"/DEF_ROOT_PASSWORD	"'$user_password'"/g' $default_file

echo "修改 LAN IP 地址"
sed -i "s/192.168.2/$lan_ip/g" $default_file

echo "更新 NTP 服务器 地址"
sed -i 's/DEF_NTP_SERVER1		"2001:470:0:50::2"/DEF_NTP_SERVER1		"202.120.2.101"/g' $default_file

echo "修改 2G 无线名称"
sed -i 's/DEF_WLAN_2G_SSID	BOARD_PID "_%s"/DEF_WLAN_2G_SSID	"'$wlan_2g_ssid'"/g' $default_file

echo "修改 5G 无线名称"
sed -i 's/DEF_WLAN_5G_SSID	BOARD_PID "_5G_%s"/DEF_WLAN_5G_SSID	"'$wlan_5g_ssid'"/g' $default_file

echo "修改 2G 访客无线名称"
sed -i 's/DEF_WLAN_2G_GSSID	BOARD_PID "_GUEST_%s"/DEF_WLAN_2G_GSSID	"'$wlan_guest_2g_ssid'"/g' $default_file

echo "修改 5G 访客无线名称"
sed -i 's/DEF_WLAN_5G_GSSID	BOARD_PID "_GUEST_5G_%s"/DEF_WLAN_5G_GSSID	"'$wlan_guest_5g_ssid'"/g' $default_file

echo "修改 2.4GHz WIFI 密码"
sed -i 's/DEF_WLAN_2G_PSK		"1234567890"/DEF_WLAN_2G_PSK		"'$wlan_2g_psk'"/g' $default_file

echo "修改 5GHz WIFI 密码"
sed -i 's/DEF_WLAN_5G_PSK		"1234567890"/DEF_WLAN_5G_PSK		"'$wlan_5g_psk'"/g' $default_file

echo "更新版本号时间"
sed -i "s/FIRMWARE_BUILDS_REV=.*/FIRMWARE_BUILDS_REV=$version_time/g" ./versions.inc

#删除所有插件
sed -i '/CONFIG_FIRMWARE_INCLUDE_UVC/,$d' $config
sed -i '/^#/d' $config  #删除所有注释行
sed -i '/^$/d' $config     ## 直接删除空行

#集成插件
#echo "CONFIG_FIRMWARE_INCLUDE_LANG_CN=y" >> $config
sed -i "s/CONFIG_FIRMWARE_ENABLE_SWAP=n/CONFIG_FIRMWARE_ENABLE_SWAP=y/g" $config
for MOD in LANG_CN HDPARM PARTED EAP_PEAP HTTPS SFTP OPENSSH OPENSSL_EC OPENSSL_EXE CURL NAPT66 HTOP NANO; do
  echo "CONFIG_FIRMWARE_INCLUDE_${MOD}=y" >> $config
done

##科学上网##
#echo "CONFIG_FIRMWARE_INCLUDE_SHADOWSOCKS=n" >> $config #科学上网插件，选择n后全部有关插件都不集成
#echo "CONFIG_FIRMWARE_INCLUDE_XRAY=n" >> $config #集成xray执行文件  ~4.5M
#echo "CONFIG_FIRMWARE_INCLUDE_V2RAY=n" >> $config #集成v2ray执行文件
#echo "CONFIG_FIRMWARE_INCLUDE_TROJAN=n" >> $config #集成trojan执行文件  ~1.2M
#echo "CONFIG_FIRMWARE_INCLUDE_SSOBFS=n" >> $config #simple-obfs混淆插件
#echo "CONFIG_FIRMWARE_INCLUDE_SSSERVER=n" >> $config #SS server
#echo "CONFIG_FIRMWARE_INCLUDE_KUMASOCKS=n" >> $config #socks5
#echo "CONFIG_FIRMWARE_INCLUDE_IPT2SOCKS=n" >> $config
#echo "CONFIG_FIRMWARE_INCLUDE_MICROSOCKS=n" >> $config
#echo "CONFIG_FIRMWARE_INCLUDE_NPC=n" >> $config #npc
##广告管理##
#echo "CONFIG_FIRMWARE_INCLUDE_ADBYBY=n" >> $config #adbyby plus+
#echo "CONFIG_FIRMWARE_INCLUDE_KOOLPROXY=n" >> $config #KP广告过滤
##DNS服务##
#echo "CONFIG_FIRMWARE_INCLUDE_SMARTDNS=n" >> $config #smartdns
#echo "CONFIG_FIRMWARE_INCLUDE_SMARTDNSBIN=n" >> $config #smartdns二进制文件
#echo "CONFIG_FIRMWARE_INCLUDE_ADGUARDHOME=n" >> $config #adg DNS去AD
#echo "CONFIG_FIRMWARE_INCLUDE_DNSFORWARDER=n" >> $config #DNSFORWARDER
#echo "CONFIG_FIRMWARE_INCLUDE_CLOUDFLAREDDNS=n" >> $config #CLOUDFLAREDDNS
#echo "CONFIG_FIRMWARE_INCLUDE_NVPPROXY=n" >> $config #NVPPROXY
##文件管理##
#echo "CONFIG_FIRMWARE_INCLUDE_CADDY=n" >> $config #在线文件管理服务
#echo "CONFIG_FIRMWARE_INCLUDE_CADDYBIN=n" >> $config #集成caddu执行文件，此文件有13M,请注意固件大小
##音乐解锁##
#echo "CONFIG_FIRMWARE_INCLUDE_WYY=n" >> $config #网易云解锁
#echo "CONFIG_FIRMWARE_INCLUDE_WYYBIN=n" >> $config #网易云解锁GO版本执行文件（2M多）注意固件超大小
##内网穿透服务##
#echo "CONFIG_FIRMWARE_INCLUDE_ZEROTIER=n" >> $config #zerotier ~1.3M
#echo "CONFIG_FIRMWARE_INCLUDE_ALIDDNS=n" >> $config #aliddns
#echo "CONFIG_FIRMWARE_INCLUDE_DDNSTO=n" >> $config #ddnsto  ~0.5M
#echo "CONFIG_FIRMWARE_INCLUDE_ALDRIVER=n" >> $config  #ALDRIVER  ~3m
#echo "CONFIG_FIRMWARE_INCLUDE_SQM=n" >> $config #SQM
#echo "CONFIG_FIRMWARE_INCLUDE_WIREGUARD=n" >> $config #wireguard 10k

echo "修改后的config配置文件内容："
cat $config
