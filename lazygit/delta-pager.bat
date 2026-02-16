REM sed version
REM @echo off
REM
REM set "old=%~2"
REM set "new=%~5"
REM set "target=%~1"
REM set "old=%old:\=/%"
REM set "new=%new:\=/%"
REM
REM git --no-pager diff --no-index --no-ext-diff "%old%" "%new%"^
REM  | sed -e "s|%old%|%target%|g" -e "s|%new%|%target%|g"^
REM  | delta --paging=never --width=%LAZYGIT_COLUMNS%

perl version
@echo off
set "old=%~2"
set "new=%~5"
set "target=%~1"
set "old=%old:\=/%"
set "new=%new:\=/%"

git --no-pager diff --no-index --no-ext-diff "%old%" "%new%" | ^
perl -pe "s|\Q%old%\E|%target%|g;s|\Q%new%\E|%target%|g" | ^
delta --paging=never --width=%LAZYGIT_COLUMNS% --side-by-side --line-numbers
