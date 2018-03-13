%{
/** AUTHOR: Bryce Hutton
    DATE 3/12/2018
    Note: Lex file doesn't properly identify newlines. No idea why.
    **/
	#include <stdio.h>
	#include "zoomjoystrong.tab.h"
 	#include "zoomjoystrong.h"
 	void yyerror(const char* msg);
	int yylex();
	int width = 1024;
	int height = 768;
	 
%}

%error-verbose
%start statement_list

%union {int i; float f;};

%token END
%token END_STATEMENT
%token POINT
%token LINE
%token CIRCLE
%token RECTANGLE
%token SET_COLOR
%token INT
%token FLOAT

%type<i> INT
%type<f> FLOAT
%type<str> END
%type<str> END_STATEMENT
%type<str> POINT
%type<str> LINE
%type<str> CIRCLE
%type<str> RECTANGLE
%type<str> SET_COLOR

%%

statement_list: statement exit
		|statement statement_list exit
;

statement: rectangle_expr
	|point_expr
	|circle_expr
	|line_expr
	|color_expr
;

//Rectangle expression checks to make sure that the values are in bounds, then calls rectangle
rectangle_expr:RECTANGLE INT INT INT INT END_STATEMENT
	{
	  if((($2 <= width) && ($2 + $4 <= width)) && ($2 >=0 && $4 >= 0) && ($3 <= height) && ($5 + $3 <= height) && ($3 >= 0 && $5 >= 0)){
	    rectangle($2, $3, $4, $5);
	  }
	  else
		yyerror("Rectangle values exceed bounds");
	}
;

//Point expression checks to make sure that the values are in bounds, then calls Point
point_expr: POINT INT INT END_STATEMENT
{
  if(($2 <= width) && ($2 >=0) && ($3 <= height)  && ($3 > 0)){
	point($2, $3);
      }
      else
		yyerror("Point values exceed bounds");
    }
;

//Circle expression checks to make sure that the values are in bounds, then calls Circle
circle_expr: CIRCLE INT INT INT END_STATEMENT
{
  if((($4 + $2) <= width) && ($4 + $3) <= height && ($2 - $4) >= 0 && ($3-$4) >= 0){
      circle($2, $3, $4);
    }
    else
		yyerror("Circle values exceed bounds");
  }
;

//Line expression checks to make sure that the values are in bounds, then calls Line
line_expr: LINE INT INT INT INT END_STATEMENT
{  
  if((($2 <= width) && ($4 <= width)) && ($2 >=0 && $4 >= 0) && ($3 <= height) && ($5 <= height) && ($3 >= 0 && $5 >= 0)){
    line($2, $3, $4, $5);
  }
  else
 	 yyerror("Line values exceed bounds");
}
;

//Color expression checks to make sure that the values are in bounds, then calls color_set
color_expr: SET_COLOR INT INT INT END_STATEMENT
{
  if($2 <= 255 && $3 <= 255 && $4 <= 255 && $2 >= 0 && $3 >= 0 && $4 >= 0){
    set_color($2, $3, $4);
    }
    else
      yyerror("Color values exceed bounds");
}
;

//Exit lets you end if you put a end_statement after the end.
exit: END
| END END_STATEMENT
;

%%

int main(int argc, char** argv){
  	setup();
  	yyparse();
	finish();
	return 0;
}

void yyerror(const char* msg){
	fprintf(stderr, "ERROR: %s\n", msg);
}
