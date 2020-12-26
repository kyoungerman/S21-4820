
The install/setup process will automatically do the following steps.  If something fails (for example the configuration to connect to the database is not correct so it can not 
create the database tables) then it will refer to the steps that are not complete.  The install/setup process can be re-run and after fixing the problem and it will
pick up where it left off.

1. Set connection info in ./cfg.json and environment
2. Change title page: ./mt/TitleMainPage.html
3. Edit  configuration items at top of ./www/js/doc-index.js
4. Setup database - determine name and create database in d.b.
5. Configure database ./install-db.sh - This will also check that ./cfg.json is correct and that tables are migrated to the current setup.
6. 


