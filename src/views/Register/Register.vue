<template>
	<div class="register__container">
		<form class="register__form" @submit.prevent="handleRegister" v-if="!registrationSuccess">
			<Heading tag="h1" headingClass="text--primary font--bold">Bienvenido</Heading>
			<Input id="username" label="Nombre de Usuario" v-model="username" placeholder="Ingres tu nombre de usuario"
				minlength="4" required />
			<Input id="email" label="Correo" v-model="email" placeholder="Ingresa tu corrreo" minlength="3" required />
			<Input id="password" type="password" label="Contraseña" v-model="password"
				placeholder="Ingresa tu contraseña" minlength="8" required />
			<Button type="submit">Registrarse</Button>
		</form>
		<div class="register__login" v-if="!registrationSuccess">
			<Heading tag="h3" headingClass="subtitle text--primary font--regular">¿Ya tienes una cuenta?</Heading>
			<RouterLink to="/login">Inicia sesión aquí</RouterLink>
		</div>
		<div v-else class="register__success">
			<Heading tag="h2" headingClass="text--primary font--bold">{{ successMessage }}</Heading>
			<RouterLink to="/login">Inicia sesión aquí</RouterLink>
		</div>
	</div>
</template>

<script>
import Heading from '../../components/Heading/Heading.vue'
import Input from '../../components/Input/Input.vue'
import Button from '../../components/Button/Button.vue'
import Link from '../../components/Link/Link.vue'

export default {
	name: 'Register',
	components: {
		Heading,
		Input,
		Button,
		Link
	},
	data() {
		return {
			username: '',
			email: '',
			password: '',
			registrationSuccess: false,
			successMessage: ''
		}
	},
	methods: {
		async handleRegister(event) {
			event.preventDefault();

			const userData = {
				username: this.username,
				email: this.email,
				password: this.password
			}

			try {
				const response = await fetch('http://127.0.0.1:8080/accounts', {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json'
					},
					body: JSON.stringify(userData)
				});

				if (!response.ok) {
					throw new Error('Network response was not ok');
				}

				this.successMessage = "¡Registro exitoso!";
				this.registrationSuccess = true;
			} catch (error) {
				console.error('Error:', error);
			}
		}
	}
}
</script>

<style lang="scss" scoped>
@use './Register.scss';
</style>