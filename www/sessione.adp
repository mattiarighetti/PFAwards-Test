  <master>
    <property name="page_title">PFAwards - Test Online</property>
    
    <script language="JavaScript">
      TargetDate = "@target_date;noquote@";
      BackColor = "white";
      ForeColor = "black";
      CountActive = true;
      CountStepper = -1;
      LeadingZero = true;
      DisplayFormat = "%%M%% minuti e %%S%% secondi";
      FinishMessage = "Tempo finito!";
    </script>
    
    <div class="container">
      <center>
	<img class="center-block" style="display:inline-block;" height="250px" width="auto" src="http://images.professionefinanza.com/logos/pfawards.png">
      </center>
      <div class="panel panel-default">
	<div class="panel-body">
	  <p align="center">Stai svolgendo il quiz di @categoria;noquote@. Tempo rimasto a disposizione: <big><script language="JavaScript" src="http://scripts.hashemian.com/js/countdown.js"></script></big>. Stai rispondendo alla domanda <b>@domanda_num;noquote@</b>.<br><small><u>Ogni risposta data va confermata</u>, anche in caso di modifica. Nel righello sottostante, le domande in <span class="label label-warning">giallo</span> non hanno ancora ricevuto risposta, quelle in <span class="label label-success">verde</span> sono già state completate.</small></p>
	</div>
      </div>
      <center>
	<nav>
	  <ul class="pagination">
	    @righello;noquote@
	  </ul>
	</nav>
</center>
      <table class="table">
	<tr>
	  <td>
	    <p style="text-align:center;"><big>@domanda;noquote@</big></p>
	  </td>
	</tr>
      </table>
      <br>
	<table class="table">
	  <tr>
	    <td align="left" width="100%">
	      <formtemplate id="risposta"></formtemplate>
	    </td>
	  </tr>
	</table>
	<center>
	  <a href="consegna" class="btn btn-primary" onClick="return(confirm('Sei sicuro di voler consegnare l&rsquo;esame? L&rsquo;azione è irreversibile.'));"><span class="glyphicon glyphicon-open-file"></span> Consegna l'esame</a>
	</center>
    </div>
