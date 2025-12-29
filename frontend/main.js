const { createApp } = Vue;

const api = axios.create({
  baseURL: ''   // gateway 地址
});

createApp({
  data() {
    return {
      users: [],
      products: [],
      orders: [],

      user: { username: '', email: '' },
      product: { name: '', price: '', stock: '' },
      order: { userId: '', productId: '', quantity: '' }
    };
  },

  mounted() {
    this.loadAll();
  },

  methods: {
    loadAll() {
      this.loadUsers();
      this.loadProducts();
      this.loadOrders();
    },

    // ===== 用户 =====
    loadUsers() {
      api.get('/api/v1/users')
          .then(res => this.users = res.data);
    },

    addUser() {
      api.post('/api/v1/users', this.user)
          .then(() => {
            this.user = { username: '', email: '' };
            this.loadUsers();
          });
    },

    // ===== 商品 =====
    loadProducts() {
      api.get('/api/v1/products')
          .then(res => this.products = res.data);
    },

    addProduct() {
      api.post('/api/v1/products', this.product)
          .then(() => {
            this.product = { name: '', price: '', stock: '' };
            this.loadProducts();
          });
    },

    // ===== 订单 =====
    loadOrders() {
      api.get('/api/v1/orders')
          .then(res => this.orders = res.data);
    },

    addOrder() {
      api.post('/api/v1/orders', this.order)
          .then(() => {
            this.order = { userId: '', productId: '', quantity: '' };
            this.loadOrders();
          });
    }
  }
}).mount('#app');
