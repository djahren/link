<%inherit file="base.mako"/>

<div id="body" class="container">
	<div class="row">
		<div class="col-md-5">

% if user:
<h2>Lists</h2>
<ul>
	% for survey in surveys:
		<li>
			<a href="/survey/${survey.id}">${survey.name} - ${survey.description}</a>
			<!-- [${survey.user.username}] -->
			% for response in responses:
				% if response.survey == survey:
					<%
					line = ""
					new_count = len(survey.questions) - len(response.answers)
					if new_count:
					    line += "%d recently added" % new_count

					friend_count = 0
					other_count = 0
					for r in survey.responses:
					    if r.user in user.all_friends:
					        friend_count += 1
					    else:
					        other_count += 1
					if line and (friend_count or other_count):
					    line += ", "
					if friend_count and other_count:
					    line += "%d friends and %d others responded" % (friend_count, other_count)
					elif friend_count:
					    line += "%d friends responded" % friend_count
					elif other_count:
					    line += "%d others responded" % other_count
					%>
					% if line:
						<br>(${line})
					% endif
				% endif
			% endfor
		</li>
	% endfor
</ul>
% else:
<div class="visible-xs-block visible-sm-block">
<h2 name="login">Sign In</h2>
<center>
<form action="/user/login" method="POST">
	<table class="form">
		<tr><th>Username</th><td><input type="text" name="username"></td></tr>
		<tr><th>Password</th><td><input type="password" name="password"></td></tr>
		<tr><td colspan="2"><input type="submit" value="Sign in"></td></tr>
	</table>
</form>
</center>
<p>
</div>

<h2>Create Account</h2>
<center>
<form action="/user/create" method="POST">
	<table class="form">
		<tr><th>Username</th><td><input type="text" name="username"></td></tr>
		<tr><th>Password</th><td><input type="password" name="password1"></td></tr>
		<tr><th>Repeat</th><td><input type="password" name="password2"></td></tr>
		<tr><th>Email</th><td><input type="text" name="email" placeholder="Optional"></td></tr>
		<tr><td colspan="2"><input type="submit" value="Create"></td></tr>
	</table>
</form>
</center>

<p><h2>Latest Lists</h2>
<ul>
	% for survey in surveys:
		<li>
			${survey.name} - ${survey.description} (${len(survey.responses)} responses)
		</li>
	% endfor
</ul>
% endif
		</div>
		<div class="col-md-7">

<h2>About</h2>
<p>How this site works:</p>
<ol>
	<li>You say what you like.
	<li>Your friends say what they like.
	<li>The site tells you what you have in common.
</ol>
<h2>Why?</h2>
<p>Say I have a terrible secret that I like singing along to S-Club 7, which
I will never admit to in public. If any of my friends are also into that, then we
can find each other and have secret S-Club karaoke sessions. My other friends who
don't like S-Club will never know :D</p>
<p>This isn't foolproof; somebody could claim to like everything just to see what
matches they get - but if one of your friends does that, you should punch them
in the face until they stop doing that :3</p>

		</div>
	</div>
</div>