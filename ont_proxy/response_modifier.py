import re

TARGET_HOST = "192.168.100.1"

ADMIN_MENU_XML = """<WebConfig>
<english>
<admin>
<Item MenuLevel="1" MenuName="Status" url="">
<Item MenuLevel="2" MenuName="WAN Information" featurectrl="BBSP_FT_WAN" url="html/bbsp/waninfo/waninfo.asp" />
<Item MenuLevel="2" MenuName="VoIP Information" featurectrl="HW_VSPA_FEATURE_VOIP" url="html/voip/status/voipmaintain.asp" />
<Item MenuLevel="2" MenuName="WLAN Information" featurectrl="HW_AMP_FEATURE_WLAN" url="html/amp/wlaninfo/wlaninfo.asp" />
<Item MenuLevel="2" MenuName="Home Network Information" featurectrl="HW_AMP_FEATURE_WLAN|FT_WLAN_UPNP_EXPAND" url="html/amp/wificoverinfo/wlancoverinfo.asp" />
<Item MenuLevel="2" MenuName="Eth Port Information" url="html/amp/ethinfo/ethinfo.asp" />
<Item MenuLevel="2" MenuName="DHCP Information" featurectrl="BBSP_FT_DHCP_MAIN" url="html/bbsp/dhcpinfo/dhcpinfo.asp" />
<Item MenuLevel="2" MenuName="Optical Information" featurectrl="HW_AMP_FEATURE_OPTIC" url="html/amp/opticinfo/opticinfo.asp" />
<Item MenuLevel="2" MenuName="Battery Information" featurectrl="HW_SSMP_FEATURE_BATTERY" url="html/ssmp/batteryinfo/batteryinfo.asp" />
<Item MenuLevel="2" MenuName="Device Information" url="html/ssmp/deviceinfo/deviceinfo.asp" />
<Item MenuLevel="2" MenuName="Remote Management" featurectrl="HW_SSMP_FEATURE_TR069" url="html/ssmp/RomteInfo/acsstatus.asp" />
<Item MenuLevel="2" MenuName="User Device Information" featurectrl="BBSP_FT_DHCP_MAIN" url="html/bbsp/userdevinfo/userdevinfo.asp" />
<Item MenuLevel="2" MenuName="Service Provisioning Status" featurectrl="HW_SSMP_FT_PON_WEB_PAGE" url="html/ssmp/bss/bssinfo.asp" />
<Item MenuLevel="2" MenuName="Cloud Platform Status" featurectrl="HW_OSGI_FT_PLUGININFOWEB" url="html/ssmp/osgiplugin/pluginstatusabroad.asp" />
</Item>
<Item MenuLevel="1" MenuName="WAN" url="">
<Item MenuLevel="2" MenuName="WAN Configuration" featurectrl="BBSP_FT_WAN" url="html/bbsp/wan/wan.asp" />
<Item MenuLevel="2" MenuName="DHCP Client Option Configuration" featurectrl="BBSP_FT_DHCP_CLIENT_OPTION" url="html/bbsp/wandhcpoption/wandhcpoption.asp" />
</Item>
<Item MenuLevel="1" MenuName="LAN" url="">
<Item MenuLevel="2" MenuName="LAN Port Work Mode" featurectrl="BBSP_FT_L3" url="html/bbsp/layer3/layer3.asp" />
<Item MenuLevel="2" MenuName="LAN Host Configuration" url="html/bbsp/dhcp/dhcp.asp" />
<Item MenuLevel="2" MenuName="DHCP Server Configuration" featurectrl="BBSP_FT_DHCP_MAIN" url="html/bbsp/dhcpservercfg/dhcp2.asp" />
<Item MenuLevel="2" MenuName="DHCP Server Option Configuration" featurectrl="BBSP_FT_DHCPS_OPTION" url="html/bbsp/landhcpoption/landhcpoption.asp" />
<Item MenuLevel="2" MenuName="DHCP Static IP Configuration" featurectrl="BBSP_FT_DHCP_MAIN" url="html/bbsp/dhcpstatic/dhcpstatic.asp" />
</Item>
<Item MenuLevel="1" MenuName="PORT" url="">
<Item MenuLevel="2" MenuName="ETH" featurectrl="HW_AMP_FEATURE_P2P" url="html/amp/ethcfg/ethcfg.asp" />
<Item MenuLevel="2" MenuName="CATV" featurectrl="HW_AMP_FEATURE_BOARD_P2P_RF" url="html/amp/catvcfg/catvcfg.asp" />
<Item MenuLevel="2" MenuName="VLAN" featurectrl="BBSP_FT_RG_VLAN_RULE_CONFIG" url="html/bbsp/portinfo/portinfo.asp" />
</Item>
<Item MenuLevel="1" MenuName="IPv6" url="">
<Item MenuLevel="2" MenuName="Default Route Configuration" featurectrl="BBSP_FT_IPV6_ROUTE" url="html/bbsp/ipv6defaultroute/defaultroute.asp" />
<Item MenuLevel="2" MenuName="Static Route Configuration" featurectrl="BBSP_FT_IPV6_ROUTE" url="html/bbsp/ipv6staticroute/ipv6staticroute.asp" />
<Item MenuLevel="2" MenuName="LAN Address Configuration" featurectrl="BBSP_FT_IPV6_LANDEV" url="html/bbsp/lanaddress/lanaddress.asp" />
<Item MenuLevel="2" MenuName="DHCPv6 Static IP Configuration" featurectrl="BBSP_FT_IPV6_DHCP6S" url="html/bbsp/dhcpstaticaddr/dhcpstaticaddress.asp" />
<Item MenuLevel="2" MenuName="DHCPv6 Information" featurectrl="BBSP_FT_IPV6_DHCP6S" url="html/bbsp/dhcpv6info/dhcpv6info.asp" />
<Item MenuLevel="2" MenuName="Port Mapping Configuration" featurectrl="BBSP_FT_IPV6_PORTMAPPING" url="html/bbsp/ipv6portmapping/ipv6portmapping.asp" />
<Item MenuLevel="2" MenuName="IP Filter Configuration" featurectrl="BBSP_FT_IPV6_IPFILTER" url="html/bbsp/ipv6ipincoming/ipv6ipincoming.asp" />
</Item>
<Item MenuLevel="1" MenuName="WLAN" url="">
<Item MenuLevel="2" MenuName="WLAN Basic Configuration" featurectrl="HW_AMP_FEATURE_SINGLE_WLAN" url="html/amp/wlanbasic/WlanBasic.asp" />
<Item MenuLevel="2" MenuName="WLAN Advanced Configuration" featurectrl="HW_AMP_FEATURE_SINGLE_WLAN" url="html/amp/wlanadv/WlanAdvance.asp" />
<Item MenuLevel="2" MenuName="2.4G Basic Network Settings" featurectrl="HW_AMP_FEATURE_DOUBLE_WLAN" url="html/amp/wlanbasic/WlanBasic.asp?2G" />
<Item MenuLevel="2" MenuName="2.4G Advanced Network Settings" featurectrl="HW_AMP_FEATURE_DOUBLE_WLAN" url="html/amp/wlanadv/WlanAdvance.asp?2G" />
<Item MenuLevel="2" MenuName="5G Basic Network Settings" featurectrl="HW_AMP_FEATURE_DOUBLE_WLAN" url="html/amp/wlanbasic/WlanBasic.asp?5G" />
<Item MenuLevel="2" MenuName="5G Advanced Network Settings" featurectrl="HW_AMP_FEATURE_DOUBLE_WLAN" url="html/amp/wlanadv/WlanAdvance.asp?5G" />
<Item MenuLevel="2" MenuName="Automatic Wi-Fi Shutdown" featurectrl="HW_AMP_FEATURE_WLAN" url="html/amp/wifische/WlanSchedule.asp" />
<Item MenuLevel="2" MenuName="Wi-Fi Coverage Management" featurectrl="HW_AMP_FEATURE_WLAN|FT_WLAN_UPNP_EXPAND" url="html/amp/wificovercfg/wifiCover.asp" />
<Item MenuLevel="2" MenuName="Guest Network Configuration" featurectrl="FT_LAN_GUESTWIFI_POOL" url="html/amp/wlanbasic/WlanGuestWifi.asp" />
<Item MenuLevel="2" MenuName="Multi-AP" featurectrl="HW_AMP_FEATURE_WLAN" url="html/amp/wlaninfo/easymeshTopo.asp" />
</Item>
<Item MenuLevel="1" MenuName="Security" url="">
<Item MenuLevel="2" MenuName="Firewall Level Configuration" featurectrl="BBSP_FT_FIREWALL" url="html/bbsp/firewalllevel/firewalllevel.asp" />
<Item MenuLevel="2" MenuName="IP Filter Configuration" featurectrl="BBSP_FT_IPFILTERIN" url="html/bbsp/ipincoming/ipincoming.asp" />
<Item MenuLevel="2" MenuName="MAC Filter Configuration" featurectrl="BBSP_FT_MACFILTER" url="html/bbsp/macfilter/macfilter.asp" />
<Item MenuLevel="2" MenuName="URL Filter Configuration" featurectrl="BBSP_FT_PARENTAL_CTRL_URL_FLT" url="html/bbsp/urlfiltersetting/urlfiltersetting.asp" />
<Item MenuLevel="2" MenuName="DoS Configuration" featurectrl="BBSP_FT_WAN" url="html/bbsp/Dos/Dos.asp" />
<Item MenuLevel="2" MenuName="Device Access Control" featurectrl="BBSP_FT_WAN" url="html/bbsp/acl/acl.asp" />
<Item MenuLevel="2" MenuName="WAN Access Control Configuration" featurectrl="BBSP_FT_WAN" url="html/bbsp/wanacl/wanacl.asp" />
</Item>
<Item MenuLevel="1" MenuName="Route" url="">
<Item MenuLevel="2" MenuName="Default Route Configuration" featurectrl="BBSP_FT_ROUTE" url="html/bbsp/route/route.asp" />
<Item MenuLevel="2" MenuName="Static Route Configuration" featurectrl="BBSP_FT_ROUTE_STATIC" url="html/bbsp/staticroute/staticroute.asp" />
<Item MenuLevel="2" MenuName="Dynamic Route Configuration" featurectrl="FT_RIP_DYNAMIC_ROUTE" url="html/bbsp/dynamicroute/dynamicroute.asp" />
<Item MenuLevel="2" MenuName="Policy Route Configuration" featurectrl="BBSP_FT_ROUTE_POLICY" url="html/bbsp/policyroute/policyroute.asp" />
<Item MenuLevel="2" MenuName="VLAN Binding Configuration" featurectrl="BBSP_FT_ROUTE_POLICY" url="html/bbsp/vlanctc/vlanctc.asp" />
<Item MenuLevel="2" MenuName="Service Route Configuration" featurectrl="BBSP_FT_ROUTE_POLICY" url="html/bbsp/serviceroute/serviceroute.asp" />
<Item MenuLevel="2" MenuName="Routing Table" featurectrl="BBSP_FT_ROUTE" url="html/bbsp/routeinfo/routeinfo.asp" />
</Item>
<Item MenuLevel="1" MenuName="Forward Rules" url="">
<Item MenuLevel="2" MenuName="PCP Configuration" featurectrl="BBSP_FT_PCP" url="html/bbsp/pcp/pcp.asp" />
<Item MenuLevel="2" MenuName="DMZ Configuration" featurectrl="BBSP_FT_DMZ_IP" url="html/bbsp/dmz/dmz.asp" />
<Item MenuLevel="2" MenuName="Port Mapping Configuration" featurectrl="BBSP_FT_PORTMAP_IP" url="html/bbsp/portmapping/portmapping.asp" />
<Item MenuLevel="2" MenuName="Port Trigger Configuration" featurectrl="BBSP_FT_PORTTRIGGER_IP" url="html/bbsp/porttrigger/porttrigger.asp" />
<Item MenuLevel="2" MenuName="IP Mapping Configuration" featurectrl="BBSP_FT_SNAT_IPMAPPING" url="html/bbsp/ipmapping/ipmapping.asp" />
</Item>
<Item MenuLevel="1" MenuName="Network Application" url="">
<Item MenuLevel="2" MenuName="USB Application" featurectrl="SSMP_FT_SHOWFTPPAGE" url="html/ssmp/usbftp/usbhost.asp" />
<Item MenuLevel="2" MenuName="ALG Configuration" featurectrl="BBSP_FT_ALG" url="html/bbsp/alg/alg.asp" />
<Item MenuLevel="2" MenuName="UPnP Configuration" featurectrl="BBSP_FT_UPNP_MAIN" url="html/bbsp/upnp/upnp.asp" />
<Item MenuLevel="2" MenuName="ARP Configuration" featurectrl="BBSP_FT_ARP" url="html/bbsp/arp/arp.asp" />
<Item MenuLevel="2" MenuName="DDNS Configuration" featurectrl="BBSP_FT_DDNS_IP" url="html/bbsp/ddns/ddns.asp" />
<Item MenuLevel="2" MenuName="IGMP Configuration" featurectrl="BBSP_FT_MULTICAST_WANPROXY" url="html/bbsp/igmp/igmp.asp" />
<Item MenuLevel="2" MenuName="DNS Configuration" featurectrl="BBSP_FT_L3_ALL" url="html/bbsp/dnsconfiguration/dnsconfigcommon.asp" />
</Item>
<Item MenuLevel="1" MenuName="Voice" url="">
<Item MenuLevel="2" MenuName="VoIP Basic Configuration" featurectrl="HW_VSPA_FEATURE_VOIP" url="html/voip/voipinterface/voipinterface.asp" />
<Item MenuLevel="2" MenuName="VoIP Advanced Configuration" featurectrl="HW_VSPA_FEATURE_VOIP" url="html/voip/voipuser/voipuser.asp" />
</Item>
<Item MenuLevel="1" MenuName="System Tools" url="">
<Item MenuLevel="2" MenuName="Restart" url="html/ssmp/reset/reset.asp" />
<Item MenuLevel="2" MenuName="Configuration File" url="html/ssmp/cfgfile/cfgfile.asp" />
<Item MenuLevel="2" MenuName="Firmware Upgrade" url="html/ssmp/fireware/firmware.asp" />
<Item MenuLevel="2" MenuName="Restore Default Configuration" url="html/ssmp/restore/restore.asp" />
<Item MenuLevel="2" MenuName="Maintenance" url="html/bbsp/maintenance/diagnosecommon.asp" />
<Item MenuLevel="2" MenuName="VoIP Statistics" featurectrl="HW_VSPA_FEATURE_VOIP" url="html/voip/statistic/voipstatistic.asp" />
<Item MenuLevel="2" MenuName="VoIP Diagnosis" featurectrl="HW_VSPA_FEATURE_VOIP" url="html/voip/diagnose/voipdiagnose.asp" />
<Item MenuLevel="2" MenuName="Remote Mirror" featurectrl="BBSP_FT_WAN" url="html/bbsp/remotepktmirror/remotepktmirror.asp"/>
<Item MenuLevel="2" MenuName="User Log" url="html/ssmp/userlog/logview.asp" />
<Item MenuLevel="2" MenuName="Debug Log" url="html/ssmp/debuglog/debuglogview.asp" />
<Item MenuLevel="2" MenuName="Firewall Log" featurectrl="BBSP_FT_FIREWALL_FLOW_LOG" url="html/bbsp/firewalllog/firewalllogview.asp" />
<Item MenuLevel="2" MenuName="One-Click Diagnosis" url="html/ssmp/maintain/smartdiagnose.asp" />
<Item MenuLevel="2" MenuName="ONT Authentication" featurectrl="HW_AMP_FEATURE_OPTIC" url="html/amp/ontauth/passwordcommon.asp" />
<Item MenuLevel="2" MenuName="Time Setting" featurectrl="BBSP_FT_SNTP" url="html/ssmp/sntp/sntp.asp" />
<Item MenuLevel="2" MenuName="TR-069" featurectrl="HW_SSMP_FEATURE_TR069" url="html/ssmp/tr069/tr069.asp"/>
<Item MenuLevel="2" MenuName="Modify Login Password" featurectrl="HW_SSMP_FEATURE_MODIFYPWDPAGE" url="html/ssmp/accoutcfg/accountadmin.asp" />
<Item MenuLevel="2" MenuName="Certificate" url="html/ssmp/tr069/IpSec.asp" />
</Item>
</admin>
</english>
</WebConfig>"""


USER_LEVEL_PATTERNS = [
    (re.compile(r"(var\s+curUserType\s*=\s*['\"])(\d+)(['\"])"), r"\g<1>0\g<3>"),
    (re.compile(r"(<%\s*HW_WEB_GetUserType\s*\(\s*\)\s*;?\s*%>)"), "0"),
]

FEATURE_UNLOCK_JS = """
<script>
(function(){
    var origGetFeature = window.HW_WEB_GetFeatureSupport;
    window.HW_WEB_GetFeatureSupport = function() { return '1'; };

    if (typeof curUserType !== 'undefined') { curUserType = '0'; }
    if (typeof sysUserType !== 'undefined') { sysUserType = '0'; }

    document.addEventListener('DOMContentLoaded', function(){
        var hidden = document.querySelectorAll('[style*="display:none"], [style*="display: none"]');
        hidden.forEach(function(el){
            if (el.id && (el.id.indexOf('menu') !== -1 || el.id.indexOf('Menu') !== -1 ||
                el.id.indexOf('admin') !== -1 || el.id.indexOf('config') !== -1)) {
                el.style.display = '';
            }
        });

        var disabled = document.querySelectorAll('[disabled]');
        disabled.forEach(function(el){ el.removeAttribute('disabled'); });

        var readonly = document.querySelectorAll('[readonly]');
        readonly.forEach(function(el){ el.removeAttribute('readonly'); });
    });
})();
</script>
"""

PWD_MODIFY_BYPASS = re.compile(r"(var\s+PwdModifyFlag\s*=\s*['\"])(\d+)(['\"])")


def should_intercept(host):
    return host and TARGET_HOST in host


def modify_user_level(body):
    for pattern, replacement in USER_LEVEL_PATTERNS:
        body = pattern.sub(replacement, body)
    return body


def bypass_pwd_modify(body):
    body = PWD_MODIFY_BYPASS.sub(r"\g<1>0\g<3>", body)
    return body


def inject_feature_unlock(body):
    if "</head>" in body:
        body = body.replace("</head>", FEATURE_UNLOCK_JS + "</head>", 1)
    elif "</body>" in body:
        body = body.replace("</body>", FEATURE_UNLOCK_JS + "</body>", 1)
    return body


def remove_display_none(body):
    body = re.sub(
        r'(style\s*=\s*["\'][^"\']*?)display\s*:\s*none\s*;?',
        r'\1',
        body,
        flags=re.IGNORECASE,
    )
    return body


def unlock_disabled_fields(body):
    body = re.sub(r'\bdisabled\s*=\s*["\']?disabled["\']?', '', body, flags=re.IGNORECASE)
    body = re.sub(r'\breadonly\s*=\s*["\']?readonly["\']?', '', body, flags=re.IGNORECASE)
    return body


def modify_response_body(body, url_path=""):
    body = modify_user_level(body)
    body = bypass_pwd_modify(body)
    body = inject_feature_unlock(body)
    body = remove_display_none(body)
    body = unlock_disabled_fields(body)
    return body


def modify_response_headers(headers):
    headers_to_remove = [
        "x-frame-options",
        "content-security-policy",
        "x-content-type-options",
    ]
    for h in headers_to_remove:
        if h in headers:
            del headers[h]

    headers["cache-control"] = "no-cache, no-store, must-revalidate"
    headers["pragma"] = "no-cache"
    return headers
