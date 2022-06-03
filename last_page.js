document.getElementById('SuperHeader').style.display='none';//remove covid and shop link
document.getElementById('HeaderComponent').style.display='none';//remove literotica button
document.getElementsByClassName("panel clearfix j_bl j_bv")[0].style.display='none'//remove story title
document.querySelector('.SAAWidget__container').style.display='none';//remove webcam pictures
document.querySelector('ul.C_fB').style.display='none';//remove explore button
document.querySelector('.buttons').style.display='none';//remove login and signup
document.getElementsByClassName('clearfix panel y_eP y_eQ')[0].style.display='none'//remove author at the beginning
document.querySelector('.a_a').style.display='none';//remove cams try out
document.getElementsByClassName('panel bf_r')[0].style.display='none';//remove public beta notice
document.querySelector('.aa_hv').style.display='none';//remove report button
document.getElementsByClassName("panel e_r e_N")[0].style.display='none';//remove share box
let ratings=document.getElementsByClassName("panel clearfix aF_lY")[0];if(ratings!==undefined)ratings.style.display='none';//remove ratings box
document.getElementsByClassName("panel clearfix aG_ml")[0].style.display='none';//remove add to box
let boxes=document.getElementsByClassName('panel z_r z_R');
if((similar_stories=boxes[0])!==undefined)similar_stories.style.display='none';//remove similar stories box
if((series=boxes[1])!==undefined)series.style.display='none';//remove similar stories box
document.querySelector('.page__extended > div:nth-child(2)').style.display='none';//remove literotica live link
document.getElementById('mainFooter').style.display='none';//remove footer panel
document.getElementsByClassName('e_r e_P')[0].style.display='none';//remove story tags box
let comments=document.getElementById('comments_block');if(comments!==null)comments.style.display='none';//remove comments if there (added later)
