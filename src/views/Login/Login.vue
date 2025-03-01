<template>
	<div class="login__container">
		<form class="login__sign-in" @submit.prevent="handleClick" v-if="!loginSuccess">
			<Heading tag="h1" headingClass="text--black font--medium">Inicia sesión</Heading>
			<Input 
                id="username" 
                label="Nombre de usuario" 
                v-model="username" 
                :class="{ 'error': invalidUser }" 
                placeholder="Ingresa tu nombre de usuario"
				required
            />
			<p v-if="invalidUser" class="error">{{ invalidUserMessage }}</p>
            <Input 
                id="password" 
                type="password" 
                label="Contraseña" 
                v-model="password" 
                :class="{ 'error': invalidUser }" 
                placeholder="Ingresa tu contraseña"
				required
            />
			<p v-if="invalidUser" class="error">{{ invalidUserMessage }}</p>
			<Button type="submit">Ingresar</Button>
		</form>
		<div class="login__register" v-if="!loginSuccess">
			<Heading tag="h2" headingClass="title text--white font--bold">Bienvenido!</Heading>
			<Heading tag="h3" headingClass="subtitle text--white font--regular">¿No tienes una cuenta?</Heading>
			<RouterLink to="/register" class="text--white">Registrate aquí</RouterLink>
		</div>
	</div>
</template>


<script>
import Heading from '../../components/Heading/Heading.vue'
import Input from '../../components/Input/Input.vue'
import Button from '../../components/Button/Button.vue'
import Link from '../../components/Link/Link.vue'

export default {
	name: 'Login',
	components: {
		Heading,
		Input,
		Button,
		Link
	},
	data() {
		return {
			username: '',
			password: '',
			loginSuccess: false,
			invalidUser: false,
			invalidUserMessage: ''
		}
	},
	methods: {
		async handleClick(event) {
			event.preventDefault();

			const loginData = new FormData();
			loginData.append('username', this.username);
			loginData.append('password', this.password);

			try {
				const response = await fetch('http://localhost:8080/accounts/login', {
					method: 'POST',
					body: loginData
				})

				const result = await response.json()
				
				if (response.ok) {
					this.loginSuccess = true
					
					sessionStorage.setItem('token', result.token)
					this.$router.push('/')
				} else {
					this.invalidUser = true
					this.invalidUserMessage = result.error
				}
			} catch (error) {
				console.error('Error:', error)
			}
		}
	}
}
</script>

<style lang="scss" scoped>
@use './Login.scss';
</style>