
/* GIT_B FUNCTIONS */
data work.branch;
branch = GIT_BRANCH_NEW("<Local Repo Path>", "<Commit ID>", "<Branch Name>", 0);
run;

data _null_;
rc = GIT_BRANCH_CHKOUT("<Local Repo Path>", "<Branch Name>");
run;

data _null_;
rc = GIT_BRANCH_DELETE("<Local Repo Path>", "<Branch Name>");
run;

data _null_;
rc = GIT_BRANCH_MERGE("<Local Repo Path>", "<Branch Name>", "<Author Name>", "<Author Email>");
run;



/* END GIT_B */

/* GIT_C Functions */
data work.clone;
										
RC = GIT_CLONE("<Remote Repo URL>",
				 "<Local Repo Path>",
				 "git",
				 "",
				 "<Public SSH Key file path>",
				 "<Private SSH Key file path>"
			     );
run;

data work.commit;
commit = GIT_COMMIT("<Local Repo Path>", 
                      "HEAD", 
                      "<Author Name>", 
                      "<Author Email>", 
                      "<Commit Message>");
run;

data work.commitlog;
N=1;
LENGTH COMMIT_ID $ 1024;
LENGTH AUTHOR_NAME $ 1024;
LENGTH AUTHOR_EMAIL $ 1024;
LENGTH COMMITTER_NAME $ 1024;
LENGTH COMMITTER_EMAIL $ 1024;
LENGTH MESSAGE $ 1024;
LENGTH PARENT_IDS $ 1024;
LENGTH CHILDREN_IDS $ 1024;
LENGTH STASH $ 5;
LENGTH IN_CURRENT_BRANCH $ 5;
LENGTH TIME $ 1024;

COMMIT_ID="";
AUTHOR_NAME="";
AUTHOR_EMAIL="";
COMMITTER_NAME="";
COMMITTER_EMAIL="";
MESSAGE="";
PARENT_IDS="";
CHILDREN_IDS="";
STASH="";
IN_CURRENT_BRANCH="";
TIME="";

N = GIT_COMMIT_LOG("<Local Repo Path>");
PUT N=;
DO I=1 TO N;
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "id", COMMIT_ID);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "author", AUTHOR_NAME);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "email", AUTHOR_EMAIL);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "committer", COMMITTER_NAME);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "committer_email", COMMITTER_EMAIL);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "message", MESSAGE);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "parent_ids", PARENT_IDS);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "children_ids", CHILDREN_IDS);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "stash", STASH);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "in_current_branch", IN_CURRENT_BRANCH);
	RC = GIT_COMMIT_GET(I,"<Local Repo Path>", "time", TIME); 
	PUT COMMIT_ID=;
	PUT AUTHOR_NAME=;
	PUT AUTHOR_EMAIL=;
	PUT COMMITTER_NAME=;
	PUT COMMITTER_EMAIL=;
	PUT MESSAGE=;
	PUT PARENT_IDS=;
	PUT CHILDREN_IDS=;
	PUT STASH=;
	PUT IN_CURRENT_BRANCH=;
	PUT TIME=; 
	output; 
END;
RC = GIT_COMMIT_FREE("<Local Repo Path>");
run;
proc print data=work.commitlog; run;

/* END GIT_C */

/* GIT_D Functions */
data work.diff;
LENGTH FILE_PATH $ 1024;
LENGTH DIFF_CONTENT $ 32767;
LENGTH DIFF_TYPE $ 1024;
LENGTH FILENAME $ 32;
FILE_PATH="";
DIFF_CONTENT="";
DIFF_TYPE="";
FILENAME="";
N = GIT_DIFF("<Local Repo Path>", "<Older Commit ID>", "<Newer Commit ID>");
PUT N=;
DO I=1 TO N;
	FILENAME = cats("git_diff_", I) || ".txt";
	RC = GIT_DIFF_GET(I,"<Local Repo Path>", "<Older Commit ID>", "<Newer Commit ID>", "file", FILE_PATH);
	RC = GIT_DIFF_GET(I,"<Local Repo Path>", "<Older Commit ID>", "<Newer Commit ID>", "diff_content", DIFF_CONTENT);
	RC = GIT_DIFF_TO_FILE(I, "<Local Repo Path>", "<Older Commit ID>", "<Newer Commit ID>", '<File path to output file>');
	RC = GIT_DIFF_GET(I,"<Local Repo Path>", "<Older Commit ID>", "<Newer Commit ID>", "diff_type", DIFF_TYPE);
	PUT FILE_PATH=;
	PUT DIFF_CONTENT=;
	PUT DIFF_TYPE=;
	PUT FILENAME=;
	output;
END;
RC = GIT_DIFF_FREE("<Local Repo Path>", "<Older Commit ID>", "<Newer Commit ID>");

run;
proc print data=work.diff; 
run;

data _null_;
LENGTH DIFF_CONTENT $ 32000;
DIFF_CONTENT="";
rc=GIT_DIFF_FILE_IDX("<Local Repo Path>", "<File to diff>", DIFF_CONTENT, 1, "<File path of output file>");
PUT DIFF_CONTENT=;
output;
run;

data work.delete;
RC = GIT_DELETE_REPO("<Local Repo Path>"); 
run;
/* END GIT_D */

/* GIT_F Functions */

data work.FETCH;
pull = GIT_FETCH("<Local Repo Path>", 
				  "git", 
				  "", 
				  "<Public SSH Key file path>", 
				  "<Private SSH Key file path>");
run;	

/* END GIT_F */

/* GIT_I Functions */

data work.add;
add = GIT_INDEX_ADD("<Local Repo Path>", "<File to add>", "new"); 
run;

data work.remove;
remove = GIT_INDEX_REMOVE("<Local Repo Path>", "<File to remove>");
run;

data _null_;
rc = GIT_INIT_REPO("<Local Repo Path>");
run;
/* END GIT_I */

/* GIT_P FUNCTIONS */

data work.push;
push = GIT_PUSH("<Local Repo Path>", /* Local Repo location */
				  "git", /* user name */
				  "",  /* password */
				  "<Public SSH Key file path>", /*ssh pub key location */
				  "<Private SSH Key file path>"); /* ssh priv key location */
run;


/* Pull Example */
data work.pull;
pull = GIT_PULL("<Local Repo Path>", 
				  "git", 
				  "", 
				  "<Public SSH Key file path>", 
				  "<Private SSH Key file path>");
run;

/* END GIT_P */

/* GIT_R Functions */
data work.reset;
reset = GIT_RESET("<Local Repo Path>", "<Commit ID>", "HARD"); /* HARD, MIXED, SOFT */
run;

data _null_;
rc = GIT_RESET_FILE("<Local Repo Path>", "cowboy.sas");
run;

data _null_;
rc = GIT_REBASE("<Local Repo Path>", "<Commit ID of the Current Branch>", "<Commit ID to Rebase onto>", "<Committer Name>", "<Committer Email>");
run;

/* ABORT, CONTINUE, SKIP, FINISH */
data _null_;
rc = GIT_REBASE_OP("<Local Repo Path>", "ABORT", "<Branch Name>", "<Committer Name>", "<Committer Email>");
run;

/* END GIT_R */

/* GIT_S FUNCTIONS */
DATA work.status;
    LENGTH PATH $ 1024;
    LENGTH STATUS $ 64;
    LENGTH STAGED $ 32;
    PATH="";
    STATUS="";
    STAGED="Staged";
    N=1;
    
    N=GIT_STATUS("<Local Repo Path>");
    DO I=1 TO N;
        
        RC=GIT_STATUS_GET(I,"<Local Repo Path>", "Path",Path);
        RC=GIT_STATUS_GET(I,"<Local Repo Path>", "Status",Status);
        RC=GIT_STATUS_GET(I,"<Local Repo Path>", "Staged",Staged);
        PUT PATH=;
        PUT STATUS=;
        PUT STAGED=;
        output;
    END;
    RC=GIT_STATUS_FREE("<Local Repo Path>");

RUN;

data _null_;
rc = GIT_STASH("<Local Repo Path>", "<Author Name>", "<Author Email>");
run;

data _null_;
RC = GIT_STASH_POP("<Local Repo Path>");
run;

data _null_;
RC = GIT_STASH_DROP("<Local Repo Path>", 0);
run;

data _null_;
RC = GIT_STASH_APPLY("<Local Repo Path>", 0);
run;

data _null_;
rc = GIT_SET_URL("<Local Repo Path>", "<Remote Repo URL>");
run;

/* END GIT_S */

/* GIT_V FUNCTIONS */

data work.version;
RC = GIT_VERSION();
put RC=;
output;
run;
proc print data=work.version; 
run;

/* END GIT_V */

