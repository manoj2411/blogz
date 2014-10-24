class ChangeUserFromComments < ActiveRecord::Migration
  def up
    # Reason beind recreate comments table is it has a "user" column which is of invalid type according to Rails, its type shows "nil"
    # #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x007ffa1bc8ecf0
    #  @coder=nil,
    #  @default=nil,
    #  @default_function=nil,
    #  @limit=nil,
    #  @name="user",
    #  @null=true,
    #  @precision=nil,
    #  @primary=false,
    #  @scale=nil,
    #  @sql_type="reference",
    #  @type=nil>

    # And we need to have a column "user_id" for users and comments associations.
    # SQLite has limited ALTER TABLE support that you can use to add a column to the end of a table or to change the name of a table. If you want to make more complex changes in the structure of a table, you will have to recreate the table... (http://www.sqlite.org/faq.html#q11)

    drop_table :comments

    create_table :comments do |t|
      t.text :message
      t.string :status
      t.references :blog, index: true
      t.references :user, index: true

      t.timestamps
    end

  end

  def down
    # Keeping this blank because pervious state of database was not consistent as we were not able to do nay changes in comments table
  end
end
