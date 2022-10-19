mkdir -p /srv/samba
chmod -R 755 /srv/samba
chown -R  nobody:nobody /srv/samba
chcon -t samba_share_t /srv/samba
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
path =  /srv/samba
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
