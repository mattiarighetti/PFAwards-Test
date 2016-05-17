ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    persona_id:integer,optional
    categoria_id:integer,optional
    esame_id:integer,optional
    return_url:optional
}
# Imposta ID persona
if {![info exists persona_id]} { 
    set persona_id [db_string query "select persona_id from crm_persone where user_id = [ad_conn user_id]"]
}
# Imposta ID Esame
if {![info exists esame_id]} {
    set esame_id [db_string query "select coalesce(max(esame_id)+1,1) from awards_esami"]
    db_dml query "insert into awards_esami (esame_id, persona_id, categoria_id) values (:esame_id, :persona_id, :categoria_id)"
}
# Imposta ID Categoria
set categoria_id [db_string query "select categoria_id from awards_esami where esame_id = :esame_id"]
if {$categoria_id eq ""} {
    ad_return_complaint 1 "Impossibile stabilire la materia d'esame."
}
ns_log notice Exam Generation. Exam ID: $esame_id Person ID: $persona_id Subject: $categoria_id
# Ciclo di inserimento 5 domande da 10 punti
db_foreach query "select d.domanda_id from awards_domande d where d.categoria_id = :categoria_id and exists (select * from awards_risposte r where r.domanda_id = d.domanda_id and r.punti = 10) order by random() limit 5" {
    set rispusr_id [db_string query "select coalesce(max(rispusr_id)+1,1) from awards_rispusr"]
    db_dml query "insert into awards_rispusr (rispusr_id, domanda_id, esame_id, item_order) values (:rispusr_id, :domanda_id, :esame_id, trunc(random()*99+1))"
}
# Ciclo di inserimento 10 domande da 5 punti
db_foreach query "select d.domanda_id from awards_domande d where d.categoria_id = :categoria_id and exists (select * from awards_risposte r where r.domanda_id = d.domanda_id and r.punti = 5) order by random() limit 10" {
    set rispusr_id [db_string query "select coalesce(max(rispusr_id)+1,1) from awards_rispusr"]
    db_dml query "insert into awards_rispusr (rispusr_id, domanda_id, esame_id, item_order) values (:rispusr_id, :domanda_id, :esame_id, trunc(random()*99+1))"
}
# Ciclo per ordinamento item_order
set counter 1
db_foreach query "select rispusr_id from awards_rispusr where esame_id = :esame_id order by item_order" {
    db_dml query "update awards_rispusr set item_order = :counter where rispusr_id = :rispusr_id"
    incr counter
}

if {![info exists return_url]} {
    set return_url [export_vars -base "index" {esame_id}]
}
ns_log notice cici $return_url
ad_returnredirect $return_url 
ad_script_abort
