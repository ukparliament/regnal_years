class CreateInitialSchema < ActiveRecord::Migration[8.0]
  def change
    create_schema "heroku_ext"

    # These are extensions that must be enabled in order to support this database
    enable_extension "pg_catalog.plpgsql"
    enable_extension "pg_stat_statements"

    create_table "initial_schemas", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    create_table "kingdoms", id: :integer, default: nil, force: :cascade do |t|
      t.string "name", limit: 255, null: false
      t.date "start_on"
      t.date "end_on"
    end

    create_table "monarchs", id: :integer, default: nil, force: :cascade do |t|
      t.string "title", limit: 255, null: false
      t.string "abbreviation", limit: 20, null: false
      t.date "date_of_birth", null: false
      t.date "date_of_death"
      t.string "wikidata_id", limit: 20, null: false
    end

    create_table "parliament_periods", id: :integer, default: nil, force: :cascade do |t|
      t.integer "number", null: false
      t.date "start_on", null: false
      t.date "end_on"
      t.string "wikidata_id", limit: 20
    end

    create_table "regnal_years", id: :serial, force: :cascade do |t|
      t.integer "number", null: false
      t.date "start_on", null: false
      t.date "end_on"
      t.integer "monarch_id", null: false
    end

    create_table "reigns", id: :integer, default: nil, force: :cascade do |t|
      t.date "start_on", null: false
      t.date "end_on"
      t.integer "kingdom_id", null: false
      t.integer "monarch_id", null: false
    end

    create_table "session_regnal_years", id: :serial, force: :cascade do |t|
      t.integer "session_id", null: false
      t.integer "regnal_year_id", null: false
    end

    create_table "sessions", id: :serial, force: :cascade do |t|
      t.integer "number", null: false
      t.date "start_on", null: false
      t.date "end_on"
      t.string "wikidata_id", limit: 20
      t.string "calendar_years_citation", limit: 50, null: false
      t.string "regnal_years_citation", limit: 50
      t.integer "parliament_period_id", null: false
    end

    add_foreign_key "regnal_years", "monarchs", name: "fk_monarch"
    add_foreign_key "reigns", "kingdoms", name: "fk_kingdom"
    add_foreign_key "reigns", "monarchs", name: "fk_monarch"
    add_foreign_key "session_regnal_years", "regnal_years", name: "fk_regnal_year"
    add_foreign_key "session_regnal_years", "sessions", name: "fk_session"
    add_foreign_key "sessions", "parliament_periods", name: "fk_parliament_period"
  end
end
