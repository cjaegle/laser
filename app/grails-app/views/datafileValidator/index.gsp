<!doctype html>
<html>
  <head>
    <meta name="layout" content="semanticUI"/>
    <title>${message(code:'laser', default:'LAS:eR')} Data import explorer</title>
  </head>

  <body>
    <div>
      <div>
        <div class="container" style="text-align:center">
          <g:form action="index" method="get">
            Datafile: <input type="file" id="datafile" name="datafile"/><br/>
            Filetype: <select name="filetype">
              <option value="SO">Subscription Offered / Master datafile</option>
              <option value="ST">Subscription Taken</option>
            </select>
          </g:form>

           <table class="ui celled la-table table">
            <g:each in="results" var="r">
              <tr>
                <td>Result</td>
              </tr>
            </g:each>
          </table>
        </div>
      </div>
    </div>
  </body>
</html>
