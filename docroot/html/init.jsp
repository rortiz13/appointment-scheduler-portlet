<%@ page contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="co.com.tecnocom.csj.core.util.dto.AppointmentConstants"%>
<%@page import="co.com.tecnocom.csj.core.util.dto.Appointment"%>
<%@page import="com.liferay.portlet.calendar.model.CalEvent"%>
<%@page import="java.util.HashSet"%>
<%@page import="com.liferay.portal.kernel.exception.PortalException"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Collections"%>
<%@page import="com.liferay.portlet.dynamicdatalists.model.DDLRecord"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="javax.portlet.PortletPreferences"%>
<%@page import="com.liferay.portal.model.Role"%>
<%@page import="java.util.List"%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="theme" %>
<%@ taglib uri="http://alloy.liferay.com/tld/aui" prefix="aui" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<portlet:defineObjects />
<theme:defineObjects></theme:defineObjects>

<%-- 
	//List<CalEvent> appointmentEvents = (List<CalEvent>) renderRequest.getAttribute("appointmentEvents");
	//List<Appointment> appointmentRequests = (List<Appointment>) renderRequest.getAttribute("appointmentRequests");
	
	//boolean isGuest = themeDisplay.getUser().isDefaultUser();
--%>

<c:set var="prefs" value="${ renderRequest.getPreferences() }" scope="page"/>
<c:set var='isGuest' value='${ themeDisplay.getUser().isDefaultUser() }'/>