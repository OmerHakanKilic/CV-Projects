#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdbool.h>
#include <sys/wait.h>

void implement_ls(char* command, char* arg1)
{
    pid_t pid= fork();
    if(pid==0)
    {
        char* args[3];
        args[0]=command;
        if(arg1 == NULL)
        {
            args[1] = NULL;
        }
        else if(strcmp(arg1, "-l")==0)
        {
            args[1] = arg1;
            args[2] = NULL;
        }
        else
        {
            printf("Error: argument %s doesn't exist.\n", arg1);
        }
        execvp(command, args);
    }
    else if (pid>0)
    {
        wait(NULL);
    }
}

void implement_cat(char* command, char* arg1)
{
    pid_t pid= fork();
    if(pid==0)
    {
        char* args[3];
        args[0]=command;
        if(arg1 == NULL)
        {
            printf("Error: file name lacking.\n");
        }
        else if(access(arg1, F_OK)!=0)
        {
            printf("File with the name %s doesn't exist\n", arg1);
        }
        else
        {
            args[1] = arg1;
            args[2] = NULL;
            execvp(command, args);
        }
    }
    else if (pid>0)
    {
        wait(NULL);
    }
}


void implement_echo(char* input)
{
    pid_t pid= fork();
    if(pid==0)
    {
        char** args= malloc(sizeof(args[0]));
        int i = 0;
        char* next_token = strtok(input, " ");
        while(next_token != NULL)
        {
            args = realloc(args, sizeof(args[0])*(i+1));
            args[i] = next_token;
            next_token =strtok(NULL, " ");
            i++;
        }
        args = realloc(args, sizeof(args[0])*(i+1));
        args[i] = NULL;
        execvp("echo", args);
        free(args);
    }
    else if (pid>0)
    {
        wait(NULL);
    }
}

void implement_pwd(char* command,char* arg1)
{
    pid_t pid= fork();

    if(pid==0)
    {
        char* args[2];
        args[0] = command;
        if(arg1 != NULL)
        {
            printf("Too many arguments for pwd.\n");
            return;
        }
        else
        {
            args[1] = arg1;
            execvp("pwd", args);
        }
    }
    else if (pid>0)
    {
        wait(NULL);
    }
}

void implement_cd(char* command, char* arg1)
{
    if(chdir(arg1)!=0)
    {
        perror("chdir() failed.\n");
    }
}

void implement_help()
{
    printf("*ls\n Lists files in a directory\n Argument: -ls optional, uses the long format");
    printf("*cat\n Shows content of a file\n");
    printf("*echo\n Argument: any text, prints the text to console\n");
    printf("*pwd\n Prints the current directory to console\n");
    printf("*cd\n Argument: directory address, changes directory to the directory of argument\n");
}

int main()
{
    bool exit_flag = false;

    while (!exit_flag)
    {
        char* input;
        size_t input_size=0;
        printf("hakan_shell>");
        getline(&input, &input_size, stdin);
        //Remove trailing new line
        input[strcspn(input, "\n")] = 0;
        char* input_to_parse = strdup(input);
        char* command = strtok(input_to_parse, " ");
        char* arg1 = strtok(NULL, " ");
        char* arg_check = strtok(NULL, " ");

        if(strcmp(command, "exit")==0)
        {
            exit_flag = true;
            break;
        }
        else if (arg_check != NULL && strcmp(command, "echo")!=0 )
        {
            printf("Error: too many arguments.\n");
        }
        else if(strcmp(command, "ls")==0)
        {
            implement_ls(command, arg1);
        }
        else if(strcmp(command, "cat")==0)
        {
            implement_cat(command, arg1);
        }
        else if(strcmp(command, "echo")==0)
        {
            implement_echo(input);
        }
        else if(strcmp(command, "pwd") == 0)
        {
            implement_pwd(command,arg1);
        }
        else if(strcmp(command, "cd")==0)
        {
            implement_cd(command, arg1);
        }
        else if(strcmp(command, "help")==0)
        {
            implement_help();
        }
        else
        {
            printf("No command named %s found.\n", command);
        }
    }
    return 0;
}
