#!perl -T

use strict;
use Test::More tests => 27;
BEGIN { use_ok('Text::Trac') };

my $p = Text::Trac->new();

isa_ok($p, 'Text::Trac');

my ($text, $html, $generated_html);

### h1 test ###
$text =<<txt;
= heading 1 =
txt

$html =<<html;
<h1 id="heading1">heading 1</h1>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### h2 test ###
$text =<<txt;
== heading 2 ==
txt

$html =<<html;
<h2 id="heading2">heading 2</h2>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### h3 test ###
$text =<<txt;
=== heading 3 ===
txt

$html =<<html;
<h3 id="heading3">heading 3</h3>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### h4 test ###
$text =<<txt;
==== heading 4 ====
txt

$html =<<html;
<h4 id="heading4">heading 4</h4>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### h5 test ###
$text =<<txt;
===== heading 5 =====
txt

$html =<<html;
<h5 id="heading5">heading 5</h5>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### bold test ###
$text =<<txt;
'''bold''' '''bold'''
txt

$html =<<html;
<p>
<strong>bold</strong> <strong>bold</strong>
</p>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### italic test ###
$text =<<txt;
''italic'' ''italic''
txt

$html =<<html;
<p>
<i>italic</i> <i>italic</i>
</p>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### bolditalic test ###
$text =<<txt;
'''''bolditalic''''' '''''bolditalic'''''
txt

$html =<<html;
<p>
<strong><i>bolditalic</i></strong> <strong><i>bolditalic</i></strong>
</p>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### underline test ###
$text =<<txt;
__underline__ __underline__
txt

$html =<<html;
<p>
<span class="underline">underline</span> <span class="underline">underline</span>
</p>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### monospace test ###
$text =<<txt;
`monospace` {{{monospace}}}
txt

$html =<<html;
<p>
<tt>monospace</tt> <tt>monospace</tt>
</p>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### strike test ###
$text =<<txt;
~~strike~~ ~~strike~~
txt

$html =<<html;
<p>
<del>strike</del> <del>strike</del>
</p>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### sup test ###
$text =<<txt;
^sup^ ^sup^
txt

$html =<<html;
<p>
<sup>sup</sup> <sup>sup</sup>
</p>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### sub test ###
$text =<<txt;
,,sub,, ,,sub,,
txt

$html =<<html;
<p>
<sub>sub</sub> <sub>sub</sub>
</p>
html

$p->parse($text);
chomp($html);
is( $p->html, $html );

### br test ###
$text =<<TXT;
line1[[BR]]line2
TXT

$html =<<HTML;
<p>
line1<br />line2
</p>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );


### p test ###
$text =<<TXT;
test
test
TXT

$html =<<HTML;
<p>
test
test
</p>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );

### ul test ###
$text =<<TXT;
 * list 1-1
 * list 1-2
   * list 2-1
   * list 2-2
TXT

$html =<<HTML;
<ul><li>list 1-1</li>
<li>list 1-2</li>
<ul><li>list 2-1</li>
<li>list 2-2</li></ul></ul>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );

### ul test ###
$text =<<TXT;
 * list 1-1
 * list 1-2
   * list 2-1
   * list 2-2
TXT

$html =<<HTML;
<ul><li>list 1-1</li>
<li>list 1-2</li>
<ul><li>list 2-1</li>
<li>list 2-2</li></ul></ul>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );

### ol test ###
$text =<<TXT;
 1. list 1-1
 1. list 1-2
   a. list a-1
   a. list a-2
TXT

$html =<<HTML;
<ol start="1"><li>list 1-1</li>
<li>list 1-2</li>
<ol class="loweralpha"><li>list a-1</li>
<li>list a-2</li></ol></ol>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );

### blockauote test ###
$text =<<TXT;
  This text is a quote from someone else.
TXT

$html =<<HTML;
<blockquote>
<p>
  This text is a quote from someone else.
</p>
</blockquote>
HTML

$p->process($text);
chomp($html);
is( $p->html, $html );

### pre test ###
$text =<<TXT;
{{{
  This is pre-formatted text.
  This also pre-formatted text.
}}}
TXT

$html =<<HTML;
<pre class="wiki">
  This is pre-formatted text.
  This also pre-formatted text.
</pre>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );

### table test ###
$text =<<TXT;
||Cell 1||Cell 2||Cell 3||
||Cell 4||Cell 5||Cell 6||
TXT

$html =<<HTML;
<table>
<tr><td>Cell 1</td><td>Cell 2</td><td>Cell 3</td></tr>
<tr><td>Cell 4</td><td>Cell 5</td><td>Cell 6</td></tr>
</table>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );

### hr test ###
$text =<<TXT;
line1
====
line2
TXT

$html =<<HTML;
<p>
line1
</p>
<hr />
<p>
line2
</p>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );

### dl test ###
$text =<<TXT;
 title1::
  content 1-1
  content 1-2
 title2::
  content 2-1
  content 2-2
  content 2-3
TXT

$html =<<HTML;
<dl>
<dt>title1</dt>
<dd>
content 1-1
content 1-2
</dd>
<dt>title2</dt>
<dd>
content 2-1
content 2-2
content 2-3
</dd>
</dl>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );

### autolink test ###

$text =<<TXT;
http://mizzy.org/
[http://mizzy.org/ Title]
TXT

$html =<<HTML;
<p>
<a class="ext-link" href="http://mizzy.org/">http://mizzy.org/</a>
<a class="ext-link" href="http://mizzy.org/">Title</a>
</p>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );

### auto image link test ###

$text =<<TXT;
http://mizzy.org/test.png
[http://mizzy.org/test.png Image]
TXT

$html =<<HTML;
<p>
<img src="http://mizzy.org/test.png" alt="http://mizzy.org/test.png" />
<img src="http://mizzy.org/test.png" alt="Image" />
</p>
HTML

$p->parse($text);
chomp($html);
is( $p->html, $html );
