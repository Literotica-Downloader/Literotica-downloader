document.getElementById('SuperHeader').style.display='none';//remove covid and shop link
document.querySelector('.SAAWidget__container').style.display='none';//remove webcam pictures
document.querySelector('ul.C_fB').style.display='none';//remove explore button
document.querySelector('.buttons').style.display='none';//remove login and signup
document.querySelector('.a_a').style.display='none';//remove cams try out
document.getElementsByClassName('panel bf_r')[0].style.display='none';//remove public beta notice
document.querySelector('.aa_hv').style.display='none';//remove report button
document.querySelector('.page__extended > div:nth-child(2)').style.display='none';//remove literotica live link
document.getElementById('mainFooter').style.display='none';//remove footer panel
//remove author details before and after story
authorboxes=document.getElementsByClassName('clearfix panel y_eP y_eQ');
authorboxes[0].style.display='none';
authorboxes[1].style.display='none';
