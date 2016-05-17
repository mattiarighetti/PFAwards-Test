<?xml version="1.0"?>
<queryset>
  <fullquery name="categoria">
    <querytext>
      SELECT c.titolo FROM awards_categorie c, awards_esami e WHERE e.categoria_id = c.categoria_id AND e.esame_id = :esame_id
    </querytext>
  </fullquery>
  <fullquery name="current_timestamp">
    <querytext>
      SELECT CURRENT_TIMESTAMP
    </querytext>
  </fullquery>
  <fullquery name="first_answer">
    <querytext>
      SELECT rispusr_id FROM awards_rispusr WHERE esame_id = :esame_id ORDER BY item_order LIMIT 1
    </querytext>
  </fullquery>
  <fullquery name="start_time">
    <querytext>
      UPDATE awards_esami SET start_time = :current_timestamp WHERE esame_id = :esame_id
    </querytext>
  </fullquery>
  <fullquery name="domanda_num">
    <querytext>
      SELECT COUNT(*)+1 FROM awards_rispusr WHERE esame_id = :esame_id AND item_order < :item_order
    </querytext>
  </fullquery>
  <fullquery name="domanda_id">
    <querytext>
      SELECT domanda_id FROM awards_rispusr WHERE rispusr_id = :rispusr_id
    </querytext>
  </fullquery>
  <fullquery name="target_date">
    <querytext>
      select to_char(start_time + (15 * interval '1 minute'), 'MM/DD/YYYY HH12:MI:SS AM') from awards_esami where esame_id = :esame_id
    </querytext>
  </fullquery>
  <fullquery name="next_question">
    <querytext>
      select rispusr_id from awards_rispusr where esame_id = :esame_id and item_order > :item_order order by item_order limit 1
    </querytext>
  </fullquery>
  <fullquery name="domanda">
    <querytext>
      SELECT testo FROM awards_domande WHERE domanda_id = :domanda_id
    </querytext>
  </fullquery>
  <fullquery name="given_answer">
    <querytext>
      SELECT risposta_id FROM awards_rispusr WHERE rispusr_id = :rispusr_id and risposta_id is not null
    </querytext>
  </fullquery>
  <fullquery name="risposte">
    <querytext>
      SELECT testo, risposta_id FROM awards_risposte WHERE domanda_id = ${domanda_id} ORDER BY RANDOM()
    </querytext>
  </fullquery>
  <fullquery name="insert_answer">
    <querytext>
      INSERT INTO awards_rispusr (risposta_id) VALUES (:risposta_id) WHERE rispusr_id = :rispusr_id
    </querytext>
  </fullquery>
  <fullquery name="update_answer">
    <querytext>
      UPDATE awards_rispusr SET risposta_id = :risposta_id WHERE rispusr_id = :rispusr_id
    </querytext>
  </fullquery>
  <fullquery name="elapsed_time">
    <querytext>
      select to_char(current_timestamp - start_time, 'MI') from awards_esami where esame_id = :esame_id
    </querytext>
  </fullquery>
    <fullquery name="righello">
    <querytext>
      SELECT rispusr_id FROM awards_rispusr WHERE esame_id = :esame_id ORDER BY item_order
    </querytext>
  </fullquery>
  <fullquery name="load_risposta">
    <querytext>
      SELECT risposta_id FROM awards_rispusr WHERE rispusr_id = :rispusr_id
    </querytext>
  </fullquery>
  <fullquery name="consegna">
    <querytext>
      update awards_esami set end_time = current_timestamp where esame_id = :esame_id
    </querytext>
  </fullquery>
</queryset>
