#!/usr/bin/perl 

use POSIX qw(fork setsid chdir close dup EXIT_FAILURE O_RDWR);

sub log_msg {
	my ($fd, $message) = @_;
	print $fd $message;
}

sub daemonize() {

	my $pid = POSIX::fork();
	die "folk() failed: $!" unless defined $pid;

	if ($pid == -1) {
		exit(EXIT_FAILURE);
	}

	if ($pid > 0) {
		exit(EXIT_SUCCESS);
	} else {

		my $LOG;
		open($LOG, '>/tmp/daemon_sample.log');
		select($LOG);
		$| = 1;

		log_msg($LOG, "Forked\n");

		if (POSIX::setsid() == -1) {
			exit(EXIT_FAILURE);
		}

		log_msg($LOG, "Created new session\n");

		if (POSIX::chdir('/') == -1) {
			exit(EXIT_FAILURE);	
		}

		log_msg($LOG, "Changed current working directory to /\n");

		foreach $i (0, 1, 2) {
			POSIX::close($i);
		}

		log_msg($LOG, "Closed stdin, stdout and stderr\n");

		POSIX::open('/dev/null', POSIX::O_RDWR);
		POSIX::dup(0);
		POSIX::dup(0);

		log_msg($LOG, "Ridirected stdin, stdout and stderr to /dev/null\n");

		while (1) {
			log_msg($LOG, "Doing business\n");
			sleep(5);
		}
	}
}

sub main() {
	daemonize();
}

main();
