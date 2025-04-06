<template>
	<Header v-if="isLoggedIn" :name="userName" />
	<main>
		<div v-if="isLoggedIn" class="home__logged-in">
			<div class="file-container">
				<FileUploader />
				<FileReader />
			</div>
            <ChatBox />
		</div>
		<div v-else class="home__logged-out">
			<Heading tag="h1" headingClass="home__logged-out__title text--primary font--bold">Bienvenido</Heading>
			<Heading tag="h2" headingClass="home__logged-out__subtitle text--black font--regular">¿Qué deseas hacer?</Heading>
			<RouterLink to="/login" class="home__logged-out__link font--bold">Iniciar sesión</RouterLink>
			<RouterLink to="/register" class="home__logged-out__link font--bold">Registrarte</RouterLink>
		</div>
	</main>
</template>

<script>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Heading from '../../components/Heading/Heading.vue'
import Header from '../../components/Header/Header.vue'
import FileUploader from '../../components/FileUploader/FileUploader.vue'
import FileReader from '../../components/FileReader/FileReader.vue'
import ChatBox from '../../components/ChatBox/ChatBox.vue'
import { backendUrl } from '../../config'

export default {
	name: 'HomeView',
	components: {
		Heading,
		Header,
		FileUploader,
		FileReader,
		ChatBox
	},
	setup() {
		const isLoggedIn = ref(false)
		const router = useRouter()
        let userName = ref('')

		const getUserName = async (token) => {	
			try {
				const response = await fetch(`${backendUrl}/accounts`, {
					method: 'GET',
					headers: {
                        'Authorization': `Bearer ${token}`
                    }
				})

				const result = await response.json()

				if (response.ok) {
					userName.value = result.username
				} else {
					console.error('Error:', result.error)
				}

			} catch (error) {
				console.error('Error:', error)
			}
		}

		onMounted(() => {
			const token = sessionStorage.getItem('token')
			
			if (token) {
				isLoggedIn.value = true
				getUserName(token)
			}
		})

		const logout = () => {
			sessionStorage.removeItem('token')
			isLoggedIn.value = false
			router.push('/login')
		}

		return {
			isLoggedIn,
			userName,
			logout
		}
	}
}
</script>

<style lang="scss" scoped>
@use './HomeView.scss';
</style>