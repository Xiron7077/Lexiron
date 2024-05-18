%{
    #include <stdio.h>
    #include <stdlib.h>
    int count = 0;
    int line_count = 1;
%}

CHARACTER           [A-Za-z]+
NUMBER              [0-9]+
KEYWORD             "string"|"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"int"|"long"|"register"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"
OPERATOR            "+"|"-"|"*"|"/"|"%"|"^"
COMPARISON          ">"|"<"|"=="|">="|"<="|"!="
ASSIGN              "="
OPERATE_AND_ASSIGN  "+="|"-="|""
IMPORT              "#include"
DEFINE              "#define"
LIBRARY             <{CHARACTER}+>|<({CHARACTER}.{CHARACTER})+>
NAMESPACE           "using namespace"
STANDARD_LIBRARY    "std"
STREAM              "<<"|">>"
STREAM_METHOD       "cout"|"cin"
STRING              \"(\\.|[^"\\])*\"
SPACE               " "
BRACKET             "("|")"
FUNCTION            {CHARACTER}*{BRACKET}*{BRACKET}
LINE_END            ";"
BRACE               "{"|"}"
NEW_LINE            "\n"

%%
{IMPORT}                {printf("LINE%d - IMPORT - %s\n", line_count, yytext); count++;}
{LIBRARY}               {printf("LINE%d - LIBRARY - %s\n", line_count, yytext); count++;}
{DEFINE}                {printf("LINE%d - DEFINE - %s\n", line_count, yytext); count++;}
{NAMESPACE}             {printf("LINE%d - NAMESPACE - %s\n", line_count, yytext); count++;}
{STANDARD_LIBRARY}      {printf("LINE%d - STANDARD_LIBRARY - %s\n", line_count, yytext); count++;}
{LINE_END}              {printf("LINE%d - LINE_END - %s\n", line_count, yytext); count++;}
{FUNCTION}              {printf("LINE%d - FUNCTION - %s\n", line_count, yytext); count++;}
{KEYWORD}               {printf("LINE%d - KEYWORD - %s\n", line_count, yytext); count++;}
{STREAM_METHOD}         {printf("LINE%d - STREAM_METHOD - %s\n", line_count, yytext); count++;}
{STRING}                {printf("LINE%d - STRING - %s\n", line_count, yytext); count++;}
{CHARACTER}             {printf("LINE%d - CHARACTER - %s\n", line_count, yytext); count++;}
{NUMBER}                {printf("LINE%d - NUMBER - %s\n", line_count, yytext); count++;}
{OPERATE_AND_ASSIGN}    {printf("LINE%d - OPERATE_AND_ASSIGN - %s\n\n", line_count, yytext); count++;}
{OPERATOR}              {printf("LINE%d - OPERATOR - %s\n", line_count, yytext); count++;}
{STREAM}                {printf("LINE%d - STREAM - %s\n", line_count, yytext); count++;}
{COMPARISON}            {printf("LINE%d - COMPARISON - %s\n", line_count, yytext); count++;}
{ASSIGN}                {printf("LINE%d - ASSIGN - %s\n", line_count, yytext); count++;}
{BRACE}                 {printf("LINE%d - BRACES - %s\n", line_count, yytext); count++;}
{BRACKET}               {printf("LINE%d - BRACKET - %s\n", line_count, yytext); count++;}
{NEW_LINE}              {printf("LINE%d - NEW_LINE - \\n\n\n", line_count); line_count++; count++;}
{SPACE}                 {count++;}
.                       {printf("LINE%d - UNREGISTERED TOKEN - %s\n", line_count, yytext); count++;}
%%

int yywrap() { return 1; }

int main() {
    FILE *fp;
    char filename[50];

    printf("Enter the filename: \n");
    scanf("%s", filename);

    fp = fopen(filename, "r");
    if (!fp) {
        perror("Failed to open file");
        return 1;
    }

    yyin = fp;
    yylex();
    fclose(fp);

    printf("\nNumber of elements are: %d\n", count);

    return 0;
}
