# Products — Public GET APIs (Customer App)

**App:** Public / Customer Flutter  
**Base:** `https://adminpapa.papabear4u.com/api/v1`  
**Date:** 30 October 2026  

No distance filter. Most routes accept **GET or POST**.  
Optional header: `X-App-Country: India` · Optional query: `lang=en`

---

## Endpoint map

| Screen | Method + path | Params |
|--------|---------------|--------|
| Product home | `GET\|POST products/getPublicHome` | country?, lang? |
| Top products | `GET\|POST products/topProducts` | lat/lng ignored |
| All products | `GET\|POST products/getAll` | cate_id?, sub_cate_id?, uid?, q?, limit? |
| By category | `GET\|POST products/getProducts` | cate_id?, sub_cate_id?, limit? |
| Search | `GET\|POST products/search` | **q REQUIRED** (aliases search/keyword) |
| Detail | `GET\|POST products/getById` | **id REQUIRED** (alias product_id); also getProductInfo |
| Variants | `GET\|POST products/getVariants` | id REQUIRED |
| Gallery | `GET\|POST products/getGallery` | id REQUIRED |
| Seller products | `GET\|POST products/getBySeller` | id = seller uid; aliases getFreelancerProducts, getSellerProducts |
| Sellers list | `GET\|POST products/getSellers` | aliases getStores, getProductSellers |
| Offers | `GET\|POST product_offers/getActive` | also getPublic / getAll / getById |
| Categories home | `GET product_categories/getHome` | — |
| Categories | `GET\|POST product_categories/getActive` | — |
| Sub categories | `GET\|POST product_sub_categories/getFromCateId` | `{ id: cate_id }` |

Also: `POST salon/getHomeData` returns `products` + `product_sellers` (no distance).

---

## Shared product object

`id`, `name`, `cover`, `original_price`, `sell_price` / `shop_price` / `amount`, `discount`, `customer_pays`, `cate_id` / `sub_cate_id`, `freelacer_id`, `stock` / `stock_qty` / `in_stock`, `rating` / `total_rating`, `in_home`, `gallery` `[{view,label,url}]`, `images_list`, `variants`, `has_variants`, `payment_methods`, `returnable` / `return_days`, `tax_*`.

---

## Flutter flow

1. Products tab / Home → `products/getPublicHome` (or `topProducts` + `product_categories/getHome`)
2. Category → `products/getProducts` `{ cate_id, sub_cate_id }`
3. Search → `products/search` `{ q }`
4. Card → `products/getById` `{ id }`
5. Optional → `getGallery` / `getVariants`
6. Store → `getBySeller` `{ id: sellerUid }`
7. Coupons → `product_offers/getActive`

**Notes:** Do not apply partner nearby radius. Prefer GET|POST for existing clients.
