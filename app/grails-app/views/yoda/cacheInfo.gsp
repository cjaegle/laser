<!doctype html>
<html>
<head>
    <meta name="layout" content="semanticUI">
    <title>${message(code:'laser')} : ${message(code:'menu.yoda.cacheInfo')}</title>
</head>
<body>

<laser:serviceInjection />

<semui:breadcrumbs>
    <semui:crumb message="menu.yoda.dash" controller="yoda" action="index"/>
    <semui:crumb message="menu.yoda.cacheInfo" class="active"/>
</semui:breadcrumbs>

<%
    // EXAMPLE:
    sessionCache = contextService.getSessionCache()
    sessionCache.put("test", "${System.currentTimeSeconds()}")
    sessionCache.get("test")
%>
<br>
<h2 class="ui icon header la-clear-before la-noMargin-top"><semui:headerIcon />${message(code:'menu.yoda.cacheInfo')}</h2>


<h3 class="ui header">Session <span class="ui label">${contextService.getSessionCache().class}</span></h3>
<g:set var="sessionCache" value="${contextService.getSessionCache()}" />

<h4 class="ui header">${sessionCache.getSession().id}
    <span class="ui label">${sessionCache.getSession().class}</span></h4>

<div class="ui segment">
    <g:if test="${sessionCache.list().size() > 0}">
        <g:each in="${contextService.getSessionCache().list()}" var="entry">
            <strong>${entry.key}</strong> ${entry.value} <br />
        </g:each>
    </g:if>

    <br />
    <g:link class="ui button"
            controller="yoda" action="cacheInfo" params="[cmd: 'clearCache', type: 'session']">Cache leeren</g:link>
</div>

<hr />

<h3 class="ui header">Ehcache <span class="ui label">${ehcacheManager.class}</span></h3>

<%
    List ehCaches = [
        ehcacheManager.getCacheNames().findAll { it -> !it.startsWith('com.k_int.') && !it.startsWith('de.laser.')},
        ehcacheManager.getCacheNames().findAll { it -> it.startsWith('com.k_int.') || it.startsWith('de.laser.')}
    ]
%>

<g:each in="${ehCaches}" var="ehCache">

    <g:each in="${ehCache}" var="cacheName">
        <g:set var="cache" value="${ehcacheManager.getCache(cacheName)}" />
        <g:set var="cacheStats" value="${cache.getStatistics()}" />

        <h4 class="ui header">${cacheName}
            <span class="ui label">${cache.class}</span>
            <%-- <span class="ui label">

                try {
                    println "disk: ${Math.round(cacheStats.getLocalDiskSizeInBytes() / 1024)} kb, "
                } catch (Exception e) {
                    println "error, "
                }
                try {
                    println "heap: ${Math.round(cacheStats.getLocalHeapSizeInBytes() / 1024)} kb / "
                } catch (Exception e) {
                    println "error / "
                }
                try {
                    println "${Math.round(cacheStats.getLocalOffHeapSizeInBytes() / 1024)} kb"
                } catch (Exception e) {
                    println "error"
                }

            </span> --%>
            <g:if test="${cache.getKeys().size() > 0}">
                <span class="ui label button" onclick="$(this).parent('h4').next('.segment').find('.cacheContent').toggleClass('hidden')">count: ${cache.getKeys().size()}</span>
            </g:if>
        </h4>

        <div class="ui segment">
            ${cache}

            <dl>
                <div class="cacheContent hidden">
                    <g:each in="${cache.getKeys().toSorted()}" var="key">
                        <g:set var="cacheEntry" value="${cache.get(key)}" />
                        <g:if test="${cacheEntry}">
                            <dt>
                                ${cacheEntry.getObjectKey() instanceof String ? cacheEntry.getObjectKey() : cacheEntry.getObjectKey().key}
                                [ version=${cacheEntry.version} : hitCount=${cacheEntry.hitCount} ]
                            </dt>
                            <dd>
                                <g:set var="objectValue" value="${cacheEntry.getObjectValue()}" />
                                <g:if test="${objectValue.getClass().getSimpleName() != 'Item'}">
                                    ${objectValue}
                                </g:if>
                            </dd>
                        </g:if>
                    </g:each>
                </div>
            </dl>

            <g:link class="ui button"
                    controller="yoda" action="cacheInfo" params="[cmd: 'clearCache', cache: cacheName, type: 'ehcache']">Cache leeren</g:link>

        </div>
    </g:each>

</g:each>

<hr />

<h3 class="ui header">Hibernate <span class="ui label">${hibernateSession.class}</span></h3>

<div class="ui segment">
    <g:each in="${hibernateSession.statistics}" var="hst">
        ${hst} <br/>
    </g:each>
</div>

<hr />

<h3 class="ui header">Plugin-Cache ; not expiring <span class="ui label">${plugincacheManager.class}</span></h3>

<g:each in="${plugincacheManager.getCacheNames()}" var="cacheName">
    <g:set var="cache" value="${plugincacheManager.getCache(cacheName)}" />

    <h4 class="ui header">${cacheName} <span class="ui label">${cache.class}</span></h4>

    <div class="ui segment">
        ${cache}

        <ul>
            <g:each in="${cache.allKeys}" var="key">
                <g:set var="cacheEntry" value="${cache.getNativeCache().get(key)}" />
                <li>${key} >> ${cacheEntry}</li>
            </g:each>
        </ul>

        <g:link class="ui button"
                controller="yoda" action="cacheInfo" params="[cmd: 'clearCache', cache: cacheName, type: 'cache']">Cache leeren</g:link>

    </div>
</g:each>


</body>
</html>