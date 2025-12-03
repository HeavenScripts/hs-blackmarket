let ALL = []
let CATS = []
let activeCat = null
let q = ""
let CART = new Map() // id -> { item, qty }

const elPanel = document.getElementById('panel')
const elSearch = document.getElementById('search')
const elBtnSearch = document.getElementById('btnSearch')
const elTabs = document.getElementById('tabs')
const elGrid = document.getElementById('grid')
const elCartItems = document.querySelector('.cart-items')
const elTotal = document.getElementById('total')
const elCheckout = document.getElementById('checkout')

const elQtyModal = document.getElementById('qty-modal')
const elQtyTitle = document.getElementById('qty-title')
const elQtyValue = document.getElementById('qty-value')
const elQtyInc = document.getElementById('qty-inc')
const elQtyDec = document.getElementById('qty-dec')
const elQtyCancel = document.getElementById('qty-cancel')
const elQtyAdd = document.getElementById('qty-add')

let pendingItemForQty = null

window.addEventListener('message', (event) => {
  const data = event.data || {}
  if (data.action === 'open') {
    const cat = data.catalog || []
    const cats = data.categories || []
    ALL = cat
    CATS = cats
    activeCat = CATS[0] || null

    elPanel.classList.remove('hidden')
    renderTabs()
    renderGrid()
    renderCart()
  }
})

elBtnSearch.onclick = () => { q = elSearch.value.trim().toLowerCase(); renderGrid() }
elSearch.addEventListener('keyup', (e)=> { if (e.key === 'Enter') elBtnSearch.click() })

function renderTabs(){
  elTabs.innerHTML = ''
  CATS.forEach(cat=>{
    const b = document.createElement('button')
    b.className = 'tab' + (cat === activeCat ? ' active':'')
    b.textContent = cat
    b.onclick = ()=>{ activeCat = cat; renderTabs(); renderGrid() }
    elTabs.appendChild(b)
  })
}

function renderGrid(){
  elGrid.innerHTML = ''
  const items = ALL.filter(i=>{
    const inCat = !activeCat || i.category === activeCat
    const inSearch = !q || (i.label || '').toLowerCase().includes(q)
    return inCat && inSearch
  })

  items.forEach(i=>{
    const card = document.createElement('div')
    card.className = 'card'

    const img = document.createElement('div')
    img.className = 'img'
    img.style.backgroundImage = `url("${i.icon}")`

    const title = document.createElement('div')
    title.className = 'title'
    title.textContent = i.label

    const price = document.createElement('div')
    price.className = 'price'
    price.textContent = `$${Number(i.price||0).toLocaleString()}`

    const add = document.createElement('button')
    add.className = 'add'
    add.textContent = 'ADD'
    add.onclick = ()=> openQtyModal(i)

    card.appendChild(img)
    card.appendChild(title)
    card.appendChild(price)
    card.appendChild(add)
    elGrid.appendChild(card)
  })
}

function openQtyModal(item){
  pendingItemForQty = item
  elQtyTitle.textContent = `Add quantity – ${item.label}`
  elQtyValue.textContent = '1'
  elQtyModal.classList.remove('hidden')
}
elQtyCancel.onclick = ()=> closeQtyModal()
elQtyInc.onclick = ()=> elQtyValue.textContent = String(Math.min(100, Number(elQtyValue.textContent)+1))
elQtyDec.onclick = ()=> elQtyValue.textContent = String(Math.max(1, Number(elQtyValue.textContent)-1))
elQtyAdd.onclick = ()=>{
  const qty = Number(elQtyValue.textContent)
  addToCart(pendingItemForQty, qty)
  closeQtyModal()
}
function closeQtyModal(){ elQtyModal.classList.add('hidden'); pendingItemForQty = null }

function addToCart(item, qty){
  if(!item || !qty) return
  const ex = CART.get(item.id)
  if(ex){ ex.qty += qty } else { CART.set(item.id, { item, qty }) }
  renderCart()
}

function removeFromCart(id){
  CART.delete(id)
  renderCart()
}

function renderCart(){
  elCartItems.innerHTML = ''
  let total = 0

  CART.forEach(({item, qty})=>{
    total += (Number(item.price)||0) * qty

    const row = document.createElement('div')
    row.className = 'cart-row'

    const name = document.createElement('div')
    name.className = 'cart-name'
    name.textContent = item.label

    const qtyBox = document.createElement('div')
    qtyBox.className = 'cart-qty'
    qtyBox.textContent = `x${qty}`

    const price = document.createElement('div')
    price.className = 'cart-price'
    price.textContent = `$${(Number(item.price)*qty).toLocaleString()}`

    const rm = document.createElement('button')
    rm.className = 'cart-remove'
    rm.textContent = 'Remove'
    rm.onclick = ()=> removeFromCart(item.id)

    row.appendChild(name); row.appendChild(qtyBox); row.appendChild(price); row.appendChild(rm)
    elCartItems.appendChild(row)
  })

  elTotal.textContent = `$${total.toLocaleString()}`
  elCheckout.disabled = CART.size === 0
}

elCheckout.onclick = async ()=>{
  if(CART.size === 0) return
  const cartArr = Array.from(CART.values()).map(({item, qty})=>({ id:item.id, qty }))
  const total = Array.from(CART.values()).reduce((s,{item,qty})=> s + (Number(item.price||0)*qty), 0)


  const res = await fetch(`https://${GetParentResourceName()}/bm:confirm`, {
    method:'POST', headers:{'Content-Type':'application/json; charset=UTF-8'},
    body: JSON.stringify({ total, count: cartArr.length })
  }).then(r=>r.json()).catch(()=>null)

  if(!res || !res.confirm) return


  fetch(`https://${GetParentResourceName()}/bm:placeCart`, {
    method:'POST', headers:{'Content-Type':'application/json; charset=UTF-8'},
    body: JSON.stringify({ cart: cartArr })
  }).then(r=>r.json()).then(ack=>{
    if(ack && ack.ok){
      CART.clear(); renderCart(); closePanel()
    }
  })
}

function closePanel(){
  elPanel.classList.add('hidden')
  fetch(`https://${GetParentResourceName()}/bm:close`, { method:'POST' })
}

document.addEventListener('keydown', (e)=>{ if(e.key==='Escape'){ closePanel() }})
