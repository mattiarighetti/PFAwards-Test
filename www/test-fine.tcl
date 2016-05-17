ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    {scaduto 0}
    esame_id:integer
}
set utente_id [db_string query "select utente_id from itfaw_esami where esame_id = :esame_id"]
if {$scaduto eq 1} {
    set expiration_banner "Hai usato tutto il tempo a disposizione."
} else {
    set expiration_banner ""
}
set fine_imp [db_string query "select end_time from itfaw_esami where esame_id = :esame_id"]
if {$fine_imp eq ""} {
    db_dml query "update itfaw_esami set end_time = current_timestamp where esame_id = :esame_id"
}
set tempo [db_string query "select to_char(end_time - start_time, 'MI:SS') from itfaw_esami where esame_id = :esame_id"]
set punteggio 0
db_foreach query "select risposta_id from itfaw_rispusr where esame_id = :esame_id" {
    if {[db_0or1row query "select punti from itfaw_risposte where risposta_id = :risposta_id"]} {
	set punti [db_string query "select punti from itfaw_risposte where risposta_id = :risposta_id"]
	set punteggio [expr {$punteggio + $punti}]
    }
}
db_dml query "update itfaw_esami set punti = :punteggio"
ad_return_template
