import email
import subprocess
import sys
#import logging

if __name__ == '__main__':

	#logging.info('Started')
	data = sys.stdin.read()

	message = email.message_from_string(data)
	from_ = 'Unknown from'
	
	if 'From' in message:
		from_ = message['From']

	subject = 'Unknown subject'
	if 'Subject' in message:
		subject = message['Subject']

	cmd = ['/usr/bin/notify-send', '-u', 'normal', '-t', '3000', '-i', '/usr/share/icons/gnome/48x48/actions/mail_new.png','%s' % from_, '%s' % subject]
	subprocess.call(cmd, env={'DISPLAY': ':0.0'})
	print data

	#logging.info(data)
	#logging.info('Finsihed')
    
    
    

