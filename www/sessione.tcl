ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 3 November, 2014
} {
    esame_id:naturalnum,optional
    {rispusr_id "0"}
}
set page_title "Sessione - PFAwards"
# Controlla utenza
if {![ad_conn user_id]} {
    ad_return_complaint 1 "<b>Utente non autorizzato</b><br>Non hai le credenziali adatte per svolgere il test selezionato. Se sei in modalità di navigazione <i>privata</i>, ti invitiamo ad uscire, ad effettuare nuovamnte il login per consentirci di salvare i cookies."
}
# Controlla ID esame e cookies
if {![info exists esame_id]} {
    set esame_id [ad_get_cookie esame_id]
    if {$esame_id eq ""} {
	ad_script_abort
    }
}
# Controllo su fine esame (se esame già finito...)
if {[db_0or1row query "select * from awards_esami where esame_id = :esame_id and end_time is not null"]} {
    ad_return_complaint 1 "La prova di esame al quale si sta tentando di accedere è già stata consegnata."
}
# Prepara descrizione categoria esame
set categoria [db_string categoria ""]
set current_timestamp [db_string current_timestamp ""]
# Se è la prima domanda (rispusr_id 0) prende la prima e controlla lo start_time
if {$rispusr_id == "0"} {
    set rispusr_id [db_string first_answer ""]
    if {![db_0or1row query "select start_time from awards_esami where start_time is not null and esame_id = :esame_id"]} {
	db_dml start_time ""
    }
}
# Imposta la target date
set target_date [db_string target_date ""]
# Numero ordine domanda sottoposta
set item_order [db_string query "select item_order from awards_rispusr where rispusr_id = :rispusr_id" -default 1]
set domanda_num [db_string domanda_num ""]
# Prepara il corpo della domanda
set domanda_id [db_string domanda_id ""]
set domanda [db_string domanda ""]
# Controllo tempo
if {[db_string elapsed_time ""] > 15} {
    db_dml consegna ""
    set mode "display"
    ad_returnredirect -allow_complete_url consegna
    ad_script_abort
} else {
    set mode "edit"
}
# Se risposta già data, prepara ad_form in edit, se no in new
if {![db_0or1row given_answer ""]} {
    set buttons [list [list "Conferma risposta" new]]
} else {
    set buttons [list [list "Aggiorna risposta" edit]]
}
ad_form -name risposta \
    -mode $mode \
    -edit_buttons $buttons \
    -has_edit 1 \
    -export {esame_id} \
    -select_query_name load_risposta \
    -form {
	rispusr_id:key
        {risposta_id:integer(radio),optional
            {label "Risposte"}
  	    {options {[db_list_of_lists risposte ""]}}
            {html {size 4}}
        }
    } -new_data {
	db_transaction {
	    db_dml insert_answer ""
	}
    } -edit_data {
	db_dml update_answer ""
    } -on_submit {
        set ctr_errori 0
        if {$ctr_errori > 0} {
            break
        }
    } -after_submit {
	# Se domanda è ultima, aggiorna solo sulla stessa pagina se no procede alla successiva
	if {$domanda_num == 15} {
	    ad_returnredirect -allow_complete_url "sessione?esame_id=$esame_id&rispusr_id=$rispusr_id"
        } else {
	    set rispusr_id [db_string next_question ""]
	    ad_returnredirect -allow_complete_url "sessione?esame_id=$esame_id&rispusr_id=$rispusr_id"
	}
	ad_script_abort
    }
set righello ""
set conta 1
set current_question $rispusr_id
db_foreach righello "" {
    if {$current_question == $rispusr_id} {
	set class "active"
    } else {
	set class ""
    }
    if {[db_0or1row given_answer ""]} {
	append righello "<li class=\"$class\"><a href=\"sessione?rispusr_id=${rispusr_id}\"><h5><span class=\"label label-success\">${conta}</span></h5></a></li>"
    } else {
	append righello "<li class=\"$class\"><a href=\"sessione?rispusr_id=${rispusr_id}\"><h5><span class=\"label label-warning\">${conta}</span></h5></a></li>"
    }
    incr conta
}
