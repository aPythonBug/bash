# Working With Processes

Use the following shortcuts to manage running processes.

- `Ctrl+C:` Interrupt (kill) the current foreground process running in in the terminal. 
			This sends the SIGINT signal to the process, which is technically just a 
			request—most processes will honor it, but some may ignore it.

- `Ctrl+Z:` Suspend the current foreground process running in bash. This sends the 
			SIGTSTP signal to the process. To return the process to the foreground
			later, use the fg process_name command.

- `Ctrl+D:` Close the bash shell. This sends an EOF (End-of-file) marker to bash, and 
			bash exits when it receives this marker. This is similar to running the 
			exit command.

