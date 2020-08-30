<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:os="http://a9.com/-/spec/opensearch/1.1/" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	
	<xsl:output method="xml" encoding="utf-8"/> 
	
	<xsl:param name="title" select="//os:LongName | //os:ShortName[not(//os:LongName)]"/>
	
	<xsl:param name="param-name">
		<xsl:call-template name="get-name"/>
	</xsl:param>
	
	<xsl:param name="action-url">
		<xsl:call-template name="get-url"/>
	</xsl:param>
	
	<xsl:param name="a-url" 
		select="concat(substring-before(//os:Url/@template, '{searchTerms}'), '%s', substring-after(//os:Url/@template, '{searchTerms}'))" />
	
	<xsl:template match="/">
		<html>
			<head>
				<link rel="search" type="application/opensearchdescription+xml" title="{$title}" id="opesn-search"/>
				<link rel="icon" href="{//os:Image}"/>
				<title><xsl:value-of select="$title"/> OpenSearch</title>
				<meta name="description" content="{//os:Description}"/>
				<style>
					h1 img{max-height: 1em;}
					:target{color: red; text-decoration: underline}
				</style>
				<script>
					setTimeout(function(){
						var link = document.getElementById("opesn-search");
						link.setAttribute("href", document.location.pathname);
						link.parentNode.appendChild(link);
					},0)
				</script>
			</head>
			<body>
				<h1><img src="{//os:Image}"/><xsl:text> </xsl:text><xsl:copy-of select="$title/node()"/> OpenSearch</h1>
				<p><xsl:copy-of select="//os:Description/node()"/></p>
				
				<xsl:if test="//os:Tags/node()">
					<p>Теги: <xsl:copy-of select="//os:Tags/node()"/></p>
				</xsl:if>
				
				Содержание:
				<ol>
					<li><a href="#адресная строка">Добавление поисковой системы через адресную строку</a></li>
					<xsl:if test="$param-name and string-length($param-name) > 0">
						<li><a href="#поле ввода">Добавление поисковой системы через поле ввода</a></li>
					</xsl:if>
					<li><a href="#закладки">Добавление поисковой системы через закладки</a></li>
					<li><a href="#проверка">Проверка работы</a></li>
				</ol>
				
				<h2 id="адресная строка">Добавление поисковой системы через адресную строку</h2>
				<p>Для добавления этой поисковой системы нажмите три точки в адресной строке и нажмите пункт "Добавить поисковую систему"</p>
				<h3>Как задать краткое имя</h3>
				<ol>
					<li>Откройте меню</li>
					<li>Нажмите пункт "Настройки"</li>
					<li>На открывшейся странице слева нужно выбрать пункт <a href="about:preferences#search">поиск</a></li>
					<li>Далее нужно найти раздел "Поиск одним щелчком"</li>
					<li>В списке найдите пункт: "<xsl:value-of select="$title"/>"</li>
					<li>Справа от него под надписью "краткое имя" сделайте двойной щелчёк</li>
					<li>В появившемся поле ввода введите слово которое вы будете использовать как ключ в адресной строке для этого поиска</li>
				</ol>
				
				<xsl:if test="$param-name and string-length($param-name) > 0">
					<h2 id="поле ввода">Добавление поисковой системы через поле ввода</h2>
					<form action="{$action-url}">
						<input name="{$param-name}"/>
					</form>
					<ol>
						<li>Щёлкните правой клавишей мыши по полю ввода</li>
						<li>В открывшемся меню выберете пункт "Добавить краткое имя для данного поиска..."</li>
						<li>В открывшемся окне в поле "Краткое имя" введите слово которое вы будете использовать как ключ в адресной строке для этого поиска</li>
						<li>Нажмите кнопку Сохранить</li>
					</ol>
				</xsl:if>
				
				<h2 id="закладки">Добавление поисковой системы через закладки</h2>
				<p>Вы можете добавить ссылку ниже в закладки и задать ей краткое имя для использования в адресной строке:<br />
				<details>
					<summary><a title="{$title}" href="{$a-url}"><xsl:value-of select="$title"/> OpenSearch</a></summary>
					<code><xsl:value-of select="$a-url"/></code>
				</details>
				</p>
				
				<ol>
					<li>Нажмите правой кнопкой мыши по ссылке чтобы открыть контекстное меню</li>
					<li>Выберите пункт "Добавить ссылку в закладки"</li>
					<li>В открывшемся окне нажмите кнопку Сохранить</li>
					<h3>Как задать краткое имя</h3>
					<li>Повторите действия 1 и 2</li>
					<li>В открывшемся окне в поле "Краткое имя" введите слово которое вы будете использовать как ключ в адресной строке для этого поиска</li>
					<li>Нажмите кнопку Сохранить</li>
				</ol>
				
				<h2 id="проверка">Проверка работы</h2>
				<ol>
					<li>Откройте новую вкладку</li>
					<li>Кликните по адресной строке</li>
					<li>Введите краткое имя которое вы выбрали для этой поисковой системы</li>
					<li>Далее введите пробел и слово "тест"</li>
					<li>Нажмите Enter</li>
				</ol>
				<p>В результате должна открыться страница этой поисковой системы с результатами поиска по введённой фразе.</p>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template name="get-name">
		<xsl:param name="url-part" select="substring-before(//os:Url/@template, '={searchTerms}')"/>
		<xsl:choose>
			<xsl:when test="substring-after($url-part, '&amp;')">
				<xsl:call-template name="get-name">
					<xsl:with-param name="url-part" select="substring-after($url-part, '&amp;')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="substring-after($url-part, '?')">
				<xsl:call-template name="get-name">
					<xsl:with-param name="url-part" select="substring-after($url-part, '?')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$url-part"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="get-url">
		<xsl:param name="url" select="//os:Url/@template"/>
		<xsl:param name="cut" select="concat($param-name ,'={searchTerms}')"/>
		<xsl:value-of select="concat(substring-before($url, $cut), substring-after($url, $cut))"/>
	</xsl:template>
	
</xsl:stylesheet>