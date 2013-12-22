# MySQLog
a.k.a. "MySQL blog"
a.k.a. "How To Pick The Wrong Tool For The Job"

# Installation
Nowhere near done so installation currently consists of:

  1. Creating a MySQL database somewhere
  2. Execute the contents of `install.sql` (which is just a dev db dump)
  3. Execute `sql/func.sql` and `sql/func/route.sql`
  4. Update conf.json with your DB credentials
  5. In the DB, find `name = 'base'` in `config` and set the value to your absolute base url *without* trailing slash

You should then be good to go.
