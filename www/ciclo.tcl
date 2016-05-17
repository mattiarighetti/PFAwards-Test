ad_page_contract {
}
db_foreach query "select persona_id, categoria_id from awards_iscritti order by random()" {
    if {![db_0or1row query "select * from awards_esami where persona_id = :persona_id and categoria_id = :categoria_id limit 1"]} {
	set esame_id [db_string query "select coalesce(max(esame_id)+trunc(random()*99+1), trunc(random()*99+1)) from awards_esami"]
	db_dml query "insert into awards_esami (esame_id, categoria_id, persona_id, attivato) values (:esame_id, :categoria_id, :persona_id, true)"
    }
}
ad_script_abort
