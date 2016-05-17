ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} 
db_foreach query "select distinct(r.esame_id) as esame_id from awards_rispusr_2 r, awards_esami_2 e where r.risposta is not null and e.pdf_doc is null and e.esame_id = r.esame_id" {
    # Prepara PDF in html
    set html "<html><table border=\"0\" width=\"100%\">"
    # Imposta titolo testata
    set title "Esame #"
    append title $esame_id
    # Imposta categoria e nome utente
    set persona_id [db_string query "select persona_id from awards_esami_2 where esame_id = :esame_id"]
    set nominativo [db_string query "select initcap(lower(nome))||' '||initcap(lower(cognome)) from crm_persone where persona_id = :persona_id"]
    set categoria [db_string query "SELECT c.titolo FROM awards_categorie c, awards_esami_2 e  WHERE e.categoria_id = c.categoria_id AND e.esame_id = :esame_id"]
    append html "<tr><td colspan=\"1\" width=\"80%\"><center><font size=\"4em\" face=\"Helvetica\"><img src=\"http://images.professionefinanza.com/logos/pfawards.png\" height=\"30px\"></img><br><br>$title</font><br><font size=\"3em\" face=\"Helvetica\">Credenziali: $nominativo <small>(Codice persona: $persona_id)</small></font><br><font size=\"3em\" face=\"Helvetica\">Categoria: <u>$categoria</u></font></td></tr></table><table border=\"1\" cellpadding=\"5\" bordercolor=\"#cbcbcb\" width=\"100%\">"
    # Ciclo di estrazione domande e risposte
    set counter 1
    db_foreach query "SELECT rispusr_id FROM awards_rispusr_2 WHERE esame_id = :esame_id ORDER BY rispusr_id" {
	# Estrae corpo della domanda
	set domanda [db_string query "SELECT d.testo FROM awards_domande_2 d, awards_rispusr_2 r WHERE d.domanda_id = r.domanda_id AND r.rispusr_id = :rispusr_id"]
	append html "<tr><td bordercolor=\"#333333\"><center><big>$counter</big></center></td><td colspan=\"2\"><font face=\"Times New Roman\" size=\"1.5em\"><b>$domanda</b></font></td></tr>"
	# Estrae risposta data
	set risposta [db_string query "SELECT risposta FROM awards_rispusr_2 WHERE rispusr_id = :rispusr_id"]
	append html "<tr><td>&nbsp;</td><td colspan=\"2\"><font face=\"Times New Roman\" size=\"2em\">$risposta</font></td></tr>"
	incr counter
    }
    append html "</table>"
    append html "</html>"
    set filenamehtml "/usr/share/openacs/packages/pfawards/www/temporary.html"
    set filenamepdf  "/usr/share/openacs/packages/pfawards/www/files/exams/exam2_"
    append filenamepdf $persona_id "_" $esame_id ".pdf"
    set link "http://www.pfawards.it/files/exams/exam2_"
    append link $persona_id "_" $esame_id ".pdf"
    set file_html [open $filenamehtml w]
    puts $file_html $html
    close $file_html
    with_catch error_msg {
	exec htmldoc --portrait --webpage --header ... --footer ... --quiet --left 1cm --right 1cm --top 1cm --bottom 1cm --fontsize 12 -f $filenamepdf $filenamehtml
    } {
	ns_log notice "errore htmldoc  <code>$error_msg </code>"
    }
    ns_unlink $filenamehtml
    db_dml query "update awards_esami_2 set stato = 'svolto', pdf_doc = '$link' where esame_id = :esame_id"
}
ad_script_abort
