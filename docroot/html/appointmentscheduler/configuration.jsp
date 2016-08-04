<%@ include file="../init.jsp" %>
<%@ taglib uri="http://liferay.com/tld/portlet" prefix="liferay-portlet" %>

<c:set var='helpMessage' value='ingrese el id de la lista de datos dinamica en la que se almacenan los tipos de cita'/>
<portlet:actionURL name="editPreferences" var="editUrl" ></portlet:actionURL>

<aui:form action='${ editUrl }' method="post" >
	<aui:input type="text" value='${ prefs.getValue("appointment-dynamic-data-list-id", "") }' name="appointment-type-dynamic-data-list-id" id="appointment-type-dynamic-data-list-id" helpMessage="${ helpMessage }">
		<aui:validator name="digits"/>
	</aui:input>
	<%--<aui:input type="text" value='${ prefs.getValue("city-dynamic-data-list-id", "") }' name="city-dynamic-data-list-id"/>
	<aui:input type="text" value='${ prefs.getValue("appointment-type-dynamic-data-list-id", "") }' name="appointment-type-dynamic-data-list-id"/>--%>
	<input type="submit"/>
</aui:form>
