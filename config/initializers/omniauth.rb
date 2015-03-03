 Rails.application.config.middleware.use OmniAuth::Builder do
   # provider :facebook, '704639302911961', '0633f8b7e8431d95d60209926d21eede', {:scope => 'email, offline_access, user_birthday'}
   # provider :facebook, '314840225339082', '99e9ec7cb88dd29985f0999859f84c83', {:scope => 'email, offline_access, user_birthday'}
   provider :facebook, '1531033310513989', '724060742bb87b6931b6410b3e85273f', {:scope => 'email, offline_access, user_birthday'}
 end
