
/*--------------------------------------------------------------
	PackageManager settings
	Enabling encryption will take considerable loading time.
--------------------------------------------------------------*/

#macro PACKAGE_CFG_TRACE_ENABLE true // console messages
#macro PACKAGE_CFG_ERROR_CHECKING_ENABLE true // error checking

#macro PACKAGE_DATA_PATH "Data/"
#macro PACKAGE_TEMP_PATH "__tempkg/"
#macro PACKAGE_FILE_EXTENSION ".pkg"
#macro PACKAGE_LOAD_SPEED 1 // time in frames to load the next content

// https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx
// when enabling encryption, your saved/loadd buffer MUST be encrypted as well.
#macro PACKAGE_ENABLE_ENCRYPTION false
#macro PACKAGE_CRYPT_KEY "hVkYp3s6"
