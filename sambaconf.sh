mkdir -p /srv/samba/share_dir
chmod -R 755 /srv/samba/share_dir
chown -R  nobody:nobody /srv/samba/share_dir
chcon -t samba_share_t /srv/samba/share_dir
mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
cat > /etc/samba/smb.conf << "EOL"
[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = rocky-8
security = user
map to guest = bad user
dns proxy = no
ntlm auth = true

[Public]
path =  /srv/samba/share_dir
browsable =yes
writable = yes
guest ok = yes
read only = no
EOL

testparm

systemctl start smb
systemctl enable smb
systemctl start nmb
systemctl enable nmb

systemctl status smb
systemctl status nmb

firewall-cmd --info-service samba
firewall-cmd --permanent --add-service=samba

firewall-cmd --reload
firewall-cmd --list-services
