<%@ include file="../../init.jsp" %>
<%@ page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.tecnocom.csj.portlet.AppointmentSchedulerPortlet" %>

<c:if test='${ isGuest }'>
<c:set var="minDate" value="${ Calendar.getInstance(locale) }" />
<% 
	Calendar minDate = Calendar.getInstance(locale);
	minDate.add(Calendar.DATE, 5);
%>

<liferay-ui:error key="invalid-department" message="invalid-department"/>
<liferay-ui:error key="invalid-city" message="invalid-city"/>
<liferay-ui:error key="invalid-date" message="invalid-date"/>
<liferay-ui:error key="invalid-appointment-hours" message="invalid-appointment-hours"/>
<liferay-ui:error key="invalid-appointment-type" message="invalid-appointment-type"/>
<liferay-ui:error key="invalid-name" message="invalid-name"/>
<liferay-ui:error key="invalid-phone" message="invalid-phone"/>
<liferay-ui:error key="invalid-email" message="invalid-email"/>
<liferay-ui:error key="could-not-create-record" message="could-not-create-record"/>

<portlet:actionURL name='createAppointment' var="createAppointmentURL"></portlet:actionURL>

<style type="text/css">
	#p_p_id<portlet:namespace/> .portlet-msg-success{
		color: black;
		font-size: 15px;
	}
</style>

<aui:form cssClass="form-reference-class" autocomplete='on' id='createAppointment' name='createAppointment' action="<%= createAppointmentURL %>"  method="post">
<div id='createAppointment'>
	<aui:fieldset id='ajax-mask-holder' label="appointment-scheduler">
		<aui:column columnWidth="80">
		<aui:column columnWidth="100">
			<div class='appointment-tip'>
				<liferay-ui:message key='schedule-your-appointment-choosing-city-sectional-and-jury-to-contact'/>
			</div>
		</aui:column>
		<aui:column columnWidth='100'>
			<div id='separator' style='height: 20px'></div>
		</aui:column>
		<aui:column columnWidth="50">
			<c:if test='${ not empty departments }'>
				<aui:column columnWidth="100" >
					<aui:column columnWidth="40" first="true">
						<div style='font-weight:bold; margin-top: 5px;'><liferay-ui:message key='appointment-department'/>:</div>
					</aui:column>
				
					<aui:column columnWidth="60" last="true">
						<aui:select name="appointment-department" inlineLabel="true" label=''>
							<option value=''><liferay-ui:message key='choose-one'/></option>
							<c:forEach var='department' items='${ departments }' >
								<option value='${ department.code }'>${ department.name }</option>
							</c:forEach>
						</aui:select>
					</aui:column>
				</aui:column>
			</c:if>
			<c:if test='${ empty departments }'>
				<aui:column columnWidth="100" >
					<div class='portlet-msg-alert'><liferay-ui:message key="department-records-empty-or-not-set"/></div>
				</aui:column>
			</c:if>
			<c:if test="${ not empty appointmentTypesDDL }">
				<aui:column columnWidth="100" >
					<aui:column columnWidth="40" first="true">
						<div style='font-weight:bold; margin-top: 5px;'><liferay-ui:message key='appointment-type'/>:</div>
					</aui:column>
				
					<aui:column columnWidth="60" last="true">
						<aui:select name="appointment-type" inlineLabel="true" label=''>
							<option value=''><liferay-ui:message key='choose-one'/></option>
							<c:forEach items='${ appointmentTypesDDL }' var='appointmentTypeRecord'>
								<option value='${ appointmentTypeRecord.recordId }'>${ appointmentTypeRecord.fields.get('appointment-type').getValue() }</option>
							</c:forEach>
						</aui:select>
					</aui:column>
				</aui:column>
			</c:if>
			<c:if test='${ empty appointmentTypesDDL }'>
				<aui:column columnWidth="100">
					<div class='portlet-msg-alert'><liferay-ui:message key="appointment-type-records-empty-or-not-set"></liferay-ui:message></div>
				</aui:column>
			</c:if>
		</aui:column>
		<aui:column columnWidth="50">
			<c:if test="${ not empty departments }">
				<aui:column columnWidth="100" >
					<aui:column columnWidth="40" first="true">
						<div style='font-weight:bold; margin-top: 5px;'><liferay-ui:message key='appointment-city'/>:</div>
					</aui:column>
					
					<aui:column columnWidth="60" last="true">
						<aui:select name="appointment-city" inlineLabel="true" label=''>
							<option value=''><liferay-ui:message key='choose-one-department'/></option>
						</aui:select>
					</aui:column>
				</aui:column>
			</c:if>
			<c:if test="${ empty departments }">
				<aui:column columnWidth="100" >
			 		<div class='portlet-msg-alert'><liferay-ui:message key="city-records-empty-or-not-set"></liferay-ui:message></div>
				</aui:column>
			</c:if>
		</aui:column>
		<aui:column columnWidth='100'>
			<div id='separator' style='height: 40px'></div>
		</aui:column>
		
		<aui:column cssClass="appointment-date" columnWidth="100">
			<aui:column columnWidth="50">
				<aui:column columnWidth="100">
					<div class='appointment-tip'>
						<liferay-ui:message key="select-appointment-date"/>*
					</div>
				</aui:column>
				<liferay-ui:input-date 
					
					dayParam="appointment-dateday"
					dayValue="<%= minDate.get(Calendar.DATE) %>"
					dayNullable="false" 
					
					yearParam="appointment-dateyear"
					yearNullable="false"  
					yearRangeEnd="<%= minDate.get(Calendar.YEAR) + 1 %>" 
					yearRangeStart="<%= Calendar.getInstance(locale).get(Calendar.YEAR) %>"
					
					monthParam="appointment-datemonth"
					monthNullable="false"
					monthValue="<%= minDate.get(Calendar.MONTH) %>"
					
					disabled="false"
					formName="appointment-date"
					>
				</liferay-ui:input-date>
			</aui:column>
			<aui:column columnWidth="50">
				
				<aui:select name="appointment-hours">
					<option value='<%= AppointmentConstants.APPOINTMENT_SCHEDULE_MORNING.ordinal() %>'> <liferay-ui:message key="morning"/> </option>
					<option value='<%= AppointmentConstants.APPOINTMENT_SCHEDULE_AFTERNOON.ordinal() %>'> <liferay-ui:message key="afternoon"/> </option>
					<option value='<%= AppointmentConstants.APPOINTMENT_SCHEDULE_ANY.ordinal() %>'> <liferay-ui:message key="any"/> </option>
				</aui:select>
			</aui:column>
		</aui:column>
		<aui:column columnWidth="100">
			<div class='appointment-blue'>
				*<liferay-ui:message key="must-schedule-five-days-in-advance"/>
			</div>
			<aui:column columnWidth='100'>
				<div id='separator' style='height: 5px'></div>
			</aui:column>
		</aui:column>
		</aui:column>
	</aui:fieldset>
	<aui:fieldset label="personal-data">
		<div class='appointment-tip'>
			<liferay-ui:message key="input-your-personal-data-to-schedule-appointment"></liferay-ui:message>
		</div>
		<aui:column columnWidth='100'>
			<div id='separator' style='height: 10px'></div>
		</aui:column>
		<aui:column columnWidth="90">
			<aui:column columnWidth="100">
				<aui:column columnWidth="50">
					<aui:column columnWidth="40" first="true">
						<div class='csj-field-title'><liferay-ui:message key='contact-name-and-last-name'/>:</div>
					</aui:column>
					<aui:column columnWidth="60">
						<aui:input label='' name="contact-name-and-last-name" type="text" inlineLabel="true" maxlength="50">
						</aui:input>
					</aui:column>
						
					<aui:column columnWidth="40" first='true'>
						<div class='csj-field-title'><liferay-ui:message key='contact-phone'/>:</div>
					</aui:column>
					<aui:column columnWidth="60">
						<aui:input label="" name="contact-phone" placeholder='<%= LanguageUtil.get(portletConfig, locale,"numbers-only") %>' type="text" inlineLabel="true"  maxlength="30">
						</aui:input>
					</aui:column>
				</aui:column>
				<aui:column columnWidth="50">
					<aui:column columnWidth="40" first="true">
						<div class='csj-field-title'><liferay-ui:message key='contact-email'/>:</div>
					</aui:column>
					<aui:column columnWidth="60">
						<aui:input label='' name="contact-email" placeholder='usuario@ejemplo.com' type="text" inlineLabel="true" maxlength="50">
						</aui:input>
					</aui:column>
				</aui:column>
			</aui:column>
			<aui:column columnWidth='100'>
				<div id='separator' style='height: 30px'></div>
			</aui:column>
			<aui:column columnWidth="50">
				<aui:input resize='none' name="comments" type="textarea" rows='6' cols='60'></aui:input>
			</aui:column>
			<aui:column columnWidth="20" cssClass="captcha-holder">
				<portlet:resourceURL  var="captchaURL"/>
				<liferay-ui:captcha url="${ captchaURL }"/>
				<button id='refresh-captcha' type="button">
					<img src="${ renderRequest.contextPath }/css/images/actualizar.png" alt="<liferay-ui:message key='refresh'/>"/>
				</button>
			</aui:column>
			<aui:column columnWidth="25" last="true">
				<div id='separator' class='captcha-error-wrapper' style='height: 72px; display: table;'>
					<liferay-ui:error key="wrong-captcha" message="wrong-captcha"/>
				</div>
			</aui:column>
		</aui:column>
		
	</aui:fieldset>
	<aui:button-row >
		<button id='create-appointment-button' type="button" ><liferay-ui:message key='send-request'/></button>
	</aui:button-row>
	</div>
</aui:form>
<aui:script use="liferay-form,aui-io-request,aui-loading-mask">
	
	YUI.AUI.defaults.FormValidator.STRINGS.fullName = "names should be letters and white spaces only";
	
	function fullNameValidation(val, fildNode, rule) {
		var fullNameRegex = /<%= AppointmentSchedulerPortlet.NAME_REGEX %>/i;
		//console.log("fullNameValidation", val, fullNameRegex);
		return fullNameRegex.test(val);
	}
	YUI.AUI.defaults.FormValidator.RULES.fullName = fullNameValidation;
	
	
	
	/* validacion campos obligatorios */
	var appointmentFormValidator = new A.FormValidator({
		boundingBox: '#<portlet:namespace/>createAppointment',
		rules:{
			// inputs
			'<portlet:namespace/>contact-name-and-last-name':{
				required: true,
				fullName: true
			},
			'<portlet:namespace/>contact-email':{
				required: true,
				email: true
			},
			'<portlet:namespace/>contact-phone':{
				required: true,
				digits:true
			},
			// selects
			'<portlet:namespace/>appointment-department':{
				required: true
			},
			'<portlet:namespace/>appointment-type':{
				required: true
			},
			'<portlet:namespace/>appointment-city':{
				required: true
			},
			'<portlet:namespace/>captchaText':{
				required: true
			}
		},
		fieldStrings:{
			'<portlet:namespace/>contact-name-and-last-name':{
				required: '<liferay-ui:message key="required"/>',
				fullName: '<liferay-ui:message key="invalid-name"/>'
			},
			'<portlet:namespace/>contact-email':{
				required: '<liferay-ui:message key="required"/>',
				email: '<liferay-ui:message key="email"/>'
			},
			'<portlet:namespace/>contact-phone':{
				required: '<liferay-ui:message key="required"/>',
				digits:'<liferay-ui:message key="digits"/>'
			}
		}
	});
	
	/* validacion para la fecha de peticion de la cita */
	A.one('#createAppointment #create-appointment-button').on('click', function(event){
		var day = parseInt(A.one('#<portlet:namespace/>appointment-dateday').val(), 10);
		var month = parseInt(A.one('#<portlet:namespace/>appointment-datemonth').val(), 10); 
		var year = parseInt(A.one('#<portlet:namespace/>appointment-dateyear').val(), 10);
		var reference = new Date();
		reference.setDate(reference.getDate() + 5);
		reference.setHours(0);
		reference.setMinutes(0);
		reference.setSeconds(0);
		reference.setMilliseconds(0);
		
		var inputDate = new Date(year, month, day);
		inputDate.setMilliseconds(0);
		if(reference.getTime()<=inputDate.getTime()){
			appointmentFormValidator.validate()
			if(! appointmentFormValidator.hasErrors()){
				A.one('#<portlet:namespace/>createAppointment').invoke('submit');
			}
		} else{
			alert(Liferay.Language.get('<liferay-ui:message key="must-schedule-five-days-in-advance"/>'));
		}
	});
	
	/* loadignmask para el ajax que trae las ciudades filtradas por departamento */
	A.one("#<portlet:namespace/>ajax-mask-holder").plug(A.LoadingMask, { background: '#000' });
	
	/* funcionalidad para el select de departamento */
	A.one('#<portlet:namespace/>appointment-department').on('change', function(){
		var departmentCode = this.val(); 
		if(departmentCode){
			/* se llena el contenido de ciudades con las ciudades correspondientes */
			A.io.request(
				'<portlet:resourceURL/>',
				{
					dataType: 'json',
					cache: true,
					autoLoad: true,
					data:{
						departmentCode: departmentCode
					},
					on:{
						success: function(){
							var data = this.get('responseData');
							var cities = data.cities;
							var content = "<option value=''><liferay-ui:message key="choose-one"/></option>";
							for(var i = 0; i < cities.length; i++ ){
								content = content.concat("<option value='", cities[i].code, "'>", cities[i].name, "</option>");
							}
							A.one("#<portlet:namespace/>appointment-city").html(content);
						},
						start: function(){
							A.one("#<portlet:namespace/>ajax-mask-holder").loadingmask.toggle();
						},
						complete: function(){
							A.one("#<portlet:namespace/>ajax-mask-holder").loadingmask.toggle();
						}
					}
				}
			);
		} else{
			/* se borra el contenido de ciudad */
			A.one("#<portlet:namespace/>appointment-city").html("<option value=''><liferay-ui:message key='choose-one-department'/></option>");
		}
	});
	
	// funcionalidad para el boton que refresca el captcha
	A.one("#refresh-captcha").on('click', function(){
		A.one('#createAppointment .captcha').attr("src", '${ captchaURL }&force=' + new Date().getMilliseconds());
		console.log('${ captchaURL }&force=' + new Date().getMilliseconds());
	});
</aui:script>
</c:if>