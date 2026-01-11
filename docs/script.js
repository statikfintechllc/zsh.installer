// Lightweight interactive behavior for docs/index.html
const sleep = (ms) => new Promise(res => setTimeout(res, ms));

// Elements
const runBtn = document.getElementById('runDemo');
const replayBtn = document.getElementById('replay');
const clearBtn = document.getElementById('clear');
const terminalContent = document.getElementById('terminalContent');
const cursor = document.getElementById('cursor');
const thumbs = Array.from(document.querySelectorAll('.thumb'));
const modal = document.getElementById('modal');
const modalImage = document.getElementById('modalImage');
const modalCaption = document.getElementById('modalCaption');
const modalClose = document.querySelector('.modal-close');
const modalPrev = document.querySelector('.modal-nav.prev');
const modalNext = document.querySelector('.modal-nav.next');
let currentThumbIndex = 0;
let running = false;

// Demo steps
const steps = [
  { type:'cmd', text:'sh -c "$(curl -fsSL https://raw.githubusercontent.com/statikfintechllc/zsh.installer/master/master/ish.zsh.installer)"', delay: 450 },
  { type:'out', text:'Detected environment: iSH (Alpine Linux)', delay: 500 },
  { type:'progress', label:'Installing packages', duration: 2200 },
  { type:'out', text:'\u2714 Packages installed', delay: 300 },
  { type:'out', text:'Cloning Oh-My-Zsh...', delay: 400 },
  { type:'progress', label:'Cloning', duration: 1800 },
  { type:'out', text:'\u2714 Oh-My-Zsh installed', delay: 300 },
  { type:'out', text:'Configuring zsh as default shell', delay: 350 },
  { type:'out', text:'Configuring Git credential helper (store)...', delay: 400 },
  { type:'out', text:'\u2714 Configuration complete', delay: 500 },
  { type:'out', text:'\u001b[32mInstallation complete! Run `zsh` to start.\u001b[0m', delay: 500 }
];

async function typeLine(text, speed=18){
  const span = document.createElement('div');
  span.className = 'line';
  terminalContent.appendChild(span);
  for(let i=0;i<text.length;i++){
    span.textContent += text[i];
    terminalContent.parentElement.scrollTop = terminalContent.parentElement.scrollHeight;
    await sleep(speed);
  }
}

async function showProgress(label, ms){
  const wrap = document.createElement('div');
  wrap.style.marginTop = '8px';
  const labelEl = document.createElement('div');
  labelEl.textContent = label;
  labelEl.style.opacity = '0.85';
  const barWrap = document.createElement('div');
  barWrap.style.background = 'rgba(255,255,255,0.06)';
  barWrap.style.height = '10px';
  barWrap.style.borderRadius = '6px';
  barWrap.style.overflow = 'hidden';
  barWrap.style.marginTop = '6px';
  const bar = document.createElement('div');
  bar.style.width = '0%';
  bar.style.height = '100%';
  bar.style.background = 'linear-gradient(90deg, var(--accent), #9f1a1a)';
  bar.style.transition = `width ${ms}ms linear`;
  barWrap.appendChild(bar);
  wrap.appendChild(labelEl);
  wrap.appendChild(barWrap);
  terminalContent.appendChild(wrap);
  terminalContent.parentElement.scrollTop = terminalContent.parentElement.scrollHeight;
  // start
  await sleep(50);
  bar.style.width = '100%';
  await sleep(ms + 80);
  const done = document.createElement('div'); done.textContent = '\u2714 ' + label + ' complete'; done.style.marginTop = '6px'; terminalContent.appendChild(done);
}

async function runDemo(){
  if(running) return;
  running = true; runBtn.disabled = true; replayBtn.disabled = true; clearBtn.disabled = true;
  terminalContent.innerHTML = '';
  for(const s of steps){
    if(s.type === 'cmd'){
      await typeLine('$ ' + s.text);
      await sleep(s.delay || 350);
    } else if(s.type === 'out'){
      const d = document.createElement('div'); d.textContent = s.text; d.style.opacity = '0.95'; terminalContent.appendChild(d);
      await sleep(s.delay || 350);
    } else if(s.type === 'progress'){
      await showProgress(s.label, s.duration || 1800);
    }
  }
  showToast('Demo finished');
  running = false; runBtn.disabled = false; replayBtn.disabled = false; clearBtn.disabled = false;
}

// Controls
runBtn.addEventListener('click', runDemo);
replayBtn.addEventListener('click', () => { terminalContent.innerHTML=''; runDemo(); });
clearBtn.addEventListener('click', () => { terminalContent.innerHTML=''; });

// Copy buttons
document.querySelectorAll('.btn.copy').forEach(b => b.addEventListener('click', async (e) => {
  const text = b.getAttribute('data-clipboard');
  try{ await navigator.clipboard.writeText(text); showToast('Copied to clipboard'); }
  catch(e){ showToast('Copy failed'); }
}));

// Thumbnails -> modal
thumbs.forEach((t,idx) => t.addEventListener('click', () => openModal(idx)));

function openModal(idx){
  currentThumbIndex = idx;
  const t = thumbs[idx];
  modalImage.src = t.dataset.src;
  modalCaption.textContent = t.querySelector('.title').textContent + ' — ' + t.querySelector('.desc').textContent;
  modal.classList.add('open'); modal.setAttribute('aria-hidden','false');
}
function closeModal(){ modal.classList.remove('open'); modal.setAttribute('aria-hidden','true'); }
function prevImage(){ currentThumbIndex = (currentThumbIndex - 1 + thumbs.length) % thumbs.length; openModal(currentThumbIndex); }
function nextImage(){ currentThumbIndex = (currentThumbIndex + 1) % thumbs.length; openModal(currentThumbIndex); }
modalClose.addEventListener('click', closeModal);
modalPrev.addEventListener('click', prevImage);
modalNext.addEventListener('click', nextImage);
modal.addEventListener('click', (e)=>{ if(e.target === modal) closeModal(); });

// keyboard navigation
document.addEventListener('keydown', (e)=>{
  if(modal.classList.contains('open')){
    if(e.key === 'Escape') closeModal();
    if(e.key === 'ArrowLeft') prevImage();
    if(e.key === 'ArrowRight') nextImage();
  }
});

// simple toast
function showToast(msg){
  const t = document.createElement('div'); t.className='toast'; t.textContent = msg; document.body.appendChild(t);
  setTimeout(()=>{ t.style.opacity = '0'; }, 1800);
  setTimeout(()=> t.remove(), 2600);
}

// small accessibility: focus management on modal open
modal.addEventListener('transitionend', ()=>{
  if(modal.classList.contains('open')) modalClose.focus();
});

// initial: preload images
thumbs.forEach(t => { const i = new Image(); i.src = t.dataset.src; });

// export for dev console
window.zshDocs = { runDemo, openModal };
