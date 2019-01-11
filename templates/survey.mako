<%inherit file="base.mako"/>
<%
def checkedIf(b):
    if b:
        return 'checked="checked"'
    return ""

def selectedIf(b):
    if b:
        return 'selected="selected"'
    return ""
%>

<div id="body" class="container">
	<div class="row">
		<div class="col-md-9">

<p>${survey.description}</p>
<p>${survey.long_description or ""}</p>

% if response:
	<%
	link = "https://link.shishnet.org/response/%d" % (response.id)
	%>
	<p>Give this link to someone so they can compare with you
	(they'll be prompted to fill in their answers first if they haven't already):
	<a href="${link}">${link}</a></p>
% endif

<form action="/response" method="POST">
	<input type="hidden" name="survey" value="${survey.id}">
	% if compare:
		<input type="hidden" name="compare" value="${compare}">
	% endif
	<p>
		Privacy:
		<br><label>
			<input type="radio" name="privacy" value="friends" ${checkedIf(response and response.privacy=="friends")|n}>
			Friends Only (Friends can see, others can't)
		</label>
		<br><label>
			<input type="radio" name="privacy" value="hidden" ${checkedIf(response and response.privacy=="hidden")|n}>
			Hidden (Response will only be given an ID number and not visibly linked to an account)
		</label>
		<br><label>
			<input type="radio" name="privacy" value="public" ${checkedIf(response and response.privacy=="public")|n}>
			Public (Show up in the list of people who answered)
		</label>
	</p>

<p id="jscontrols"></p>

<table class="zebra">
	<thead>
	<tr>
		<th>Thing</th>
		<th>
			Want / Will / Won't
			<a data-toggle="tooltip" data-original-title="Want to do / Will try for somebody else's benefit / Won't do (with the right person / conditions / etc, in each case)"><span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span></a>
		</th>
	</tr>
	</thead>
	<tbody>
<%
prev = None
%>
	% for question in sorted(survey.questions + survey.headings):
		% if question.entry_type == "heading":
		<%
		hid = question.text.replace(' ', '')
		%>
	</tbody>
	<thead>
		<tr>
			<td colspan="2">
				<!--
				<span style="float: right;">
					<span data-toggle="collapse" data-target=".s${hid}" class="s${hid} collapse in">
						<span class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span>
					</span>
					<span data-toggle="collapse" data-target=".s${hid}" class="s${hid} collapse">
						<span class="glyphicon glyphicon-chevron-down" aria-hidden="true"></span>
					</span>
				</span>
				-->
				<b>${question.text}</b>
			</td>
		</tr>
	</thead>
	<tbody class="s${hid} collapse in">
		% else:
		<%
		val = response.value(question.id) if response else 0
		%>
		<tr id="q${question.id}" class="answer a${val}">
			<td>
			% if survey.user == user:
			##	${question.id} - ${question.order}
				<a href="/question/${question.id}/up">&uarr;</a>
				<a href="/question/${question.id}/down">&darr;</a>
			##	<a href="/question/${question.id}/remove">X</a>
			% endif
				% if question.flip and question.flip == prev:
					&nbsp;&nbsp;&rarr;
				% endif
				${question.text}
				% if question.extra:
				<a data-toggle="tooltip" data-original-title="${question.extra}"><span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span></a>
				% endif
			</td>
			<td class="www">
				<label class="want">
					Yay!
					<input type="radio" name="q${question.id}" value="2" ${checkedIf(val == 2)|n}>
				</label>
				<label class="will">
					<input type="radio" name="q${question.id}" value="1" ${checkedIf(val == 1)|n}>
				</label>
				<label class="wont">
					<input type="radio" name="q${question.id}" value="-2" ${checkedIf(val == -2)|n}>
					Boo!
				</label>
				<span class="visible-md-inline visible-lg-inline">&nbsp;&nbsp;&nbsp;</span>
				<br class="visible-xs visible-sm">
				<label>
					(No response
					<input type="radio" name="q${question.id}" value="0" ${checkedIf(val == 0)|n}>)
				</label>
			</td>
			##<td>${question.extra or ""}</td>
		</tr>
		<%
		prev = question
		%>
		% endif
	% endfor
	</tbody>
</table>
<input type="submit" value="Save answers">
</form>

			##% if survey.user == user:
			<p>
			<form action="/question" method="POST">
				<input type="hidden" name="survey" value="${survey.id}">
<table class="form" style="width: 300px;">
	<tr><td>
<select name="heading">
	<option value="-1">Add to end</option>
% for heading in sorted(survey.headings):
	<option value="${heading.id}">${heading.text}</option>
% endfor
	<option value="-2">Add as heading</option>
</select>
	</td></tr>
	<tr><td><input type="text" name="q1" placeholder="Question" required="required"></td></tr>
	<tr><td><input type="text" name="q2" placeholder="Paired opposite (optional)"></td></tr>
	<tr><td><input type="text" name="q1extra" placeholder="Extra description for Q1"></td></tr>
	<tr><td><input type="submit" value="Add question"></td></tr>
</table>
			</form>
			##% endif
		</div>
		<div class="col-md-3">
			% if friends:
            <p>Friends who did this:
            <ul>
            % for fresponse in friends:
                <li><a href="/response/${fresponse.id}">${fresponse.user.username}</a></li>
            % endfor
            </ul>
            % endif

			% if others:
            <p>Other people who did this:
            <ul>
            % for oresponse in others:
                <li><a href="/response/${oresponse.id}">${oresponse.user.username}</a></li>
            % endfor
            </ul>
			% endif

			% if response:
			<form action="/response/${response.id}" method="POST">
				<input type="hidden" name="_method" value="DELETE">
				<input type="submit" value="Delete answers">
			</form>
			% endif

			% if survey.user == user:
			<form action="/survey/${survey.id}" method="POST">
				<input type="submit" value="Set order">
			</form>
			% endif
		</div>
	</div>
</div>

<script>
$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip({
        placement : 'top'
    });
});
$("#jscontrols").append($("<label><input type='checkbox' id='mark'> Highlight unresponded questions</label>"));
$("#mark").click(function(evt) {
	if($("#mark").is(":checked")) {
		console.log("hi");
		$(".answer.a0").css("background", "#FFFFDD");
	}
	else {
		console.log("bye");
		$(".answer.a0").css("background", null);
	}
});
</script>
