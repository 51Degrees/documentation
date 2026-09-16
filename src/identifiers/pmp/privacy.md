@page Identifiers_PMP_Privacy Privacy Notice Wording

<!--
REVIEW PENDING. The draft wording on this page has been written by the
engineering team and has not yet been reviewed by the 51Degrees team who
handle customer data protection questions. That review is tracked
internally. Do not present this page
as reviewed wording until that review has happened, and update this comment
when it has.
-->

A site running the Preference Management Platform asks its visitors a
question, keeps their answer, and lets an identifier be created from it.
Your privacy notice should say so. This page is a starting point for the
words, written so that you can see what actually happens and describe it
accurately.

**This is not legal advice.** The wording below is a draft to adapt, not
something to paste in unread, and your own legal team has to decide what
your notice says. If you would like to see how 51Degrees describes the same
things in its own terms, read the
[Client Services Policy](https://51degrees.com/terms/client-services-privacy-policy).

# The Four Things to Cover

## 1. The Answer the Visitor Gives

The dialog asks how the visitor wants their data used for marketing, and the
answer is kept so that the question is not asked again. The answer is one of
three values and nothing else is recorded with it beyond the time it was
given.

> When you first visit this site we ask how you would like your data used
> for marketing. Your answer is stored on your device so that we do not ask
> you again. You can change it at any time using the button at the corner of
> the page.

## 2. The Answer Shared Across a Group of Sites

Where you have turned sharing on, a visitor who agrees is asked once for the
whole group, and the answer is then held by 51Degrees in a cookie on its own
domain rather than on yours. That cookie is set from the visitor's browser
and so is a third party cookie. Say which sites the group covers, because
the dialog names the group and your notice should match.

> If you agree, we ask our technology partner 51Degrees to remember your
> answer for the other [GROUP NAME] websites as well, so that you are not
> asked again on each one. This is stored in a cookie set by 51Degrees
> rather than by us, and it holds only your answer.

## 3. The Technical Record Kept on Your Site

The 51Degrees client script keeps a small record in your site's own session
storage so that it does not ask the cloud the same question twice in one
visit. It holds the values sent on the last request, which are the values
the script gathered from the browser together with the visitor's answer, and
it is cleared when the browser session ends. Entries whose names begin
`51D_` or `fod_` belong to this. Where your own page supplies an email
address to the service, that address forms part of that record.

Both you and 51Degrees can reach that storage, which is why the two of you
are joint controllers of it.

> To avoid asking the same question twice while you are here, we keep a
> small technical record in your browser's session storage. It is removed
> when you close the tab.

## 4. The Identifier

The 51Did is created by 51Degrees from the device, the network address and
the usage the visitor chose, and it is passed to advertising partners so
that they can recognise the same browser without cookies.

Describe what it is and what limits its use. **Do not describe it as
anonymous or as privacy safe.** The protection is contractual rather than
technical, so say what the contract does.

> Where you allow marketing, 51Degrees creates a signed identifier for your
> browser and we pass it to our advertising partners. Everyone who receives
> it is contractually bound by the Model Terms for Marketing, which permit
> its use only for the purpose you chose, and the identifier itself records
> which purpose that was. The terms are published at
> https://m4ow.uk/mtm/2.txt.

The address names version 2 deliberately. A link to a document that could be
edited afterwards could never prove what the visitor's answer meant at the
time it was given, so the version in force when an identifier was created is
the one to reference.

# What the Contract Does

The Model Terms for Marketing, version 2, at <https://m4ow.uk/mtm/2.txt>,
bind every party that receives a 51Did. In short, a recipient may use the
identifier only for the usage the visitor chose, which the identifier itself
records, and the identifier says nothing on its own about who the visitor
is. That is a promise made and enforceable rather than a property of the
bytes, which is exactly why your notice should describe the promise rather
than call the identifier anonymous.

# Find Out More

- What the visitor is asked and what each answer means:
  @ref Identifiers_PMP_Preferences
- The shared answer, the cookie and the endpoint behind it:
  @ref Identifiers_PMP_Sharing
- What the identifier is and what is inside it: @ref Identifiers_51Did
- What the client script stores in the browser and why:
  @ref PipelineApi_Features_ClientSideEvidence
- The Model Terms for Marketing, version 2: <https://m4ow.uk/mtm/2.txt>
- How 51Degrees describes the same things:
  <https://51degrees.com/terms/client-services-privacy-policy>
