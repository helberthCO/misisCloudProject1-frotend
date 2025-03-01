<template>
	<div class="file-reader__container">
		<Heading tag="h2" headingClass="file-reader__title text--primary font--bold">Archivos agregados</Heading>
        <ul class="file-reader__list">
            <li class="file-reader__doc" v-for="document in documents" :key="document.id">
                <span>{{ document.name }}</span>
                <Button class="file-reader__delete" @click="deleteDocument(document.id)">Eliminar</Button>
            </li>
        </ul>
	</div>
</template>

<script>
import Button from '../Button/Button.vue';
import Heading from '../Heading/Heading.vue';
import { EventBus } from '../../eventBus';

export default {
    name: 'FileReader',
    components: {
        Button,
        Heading
    },
    data() {
        return {
            documents: []
        };
    },
    mounted() {
        this.fetchDocuments();
        EventBus.on('file-uploaded', this.fetchDocuments);
    },
    beforeDestroy() {
        EventBus.off('file-uploaded', this.fetchDocuments);
    },
    methods: {
        async fetchDocuments() {
            const token = sessionStorage.getItem("token");

            try {
                const response = await fetch("http://127.0.0.1:8080/accounts/documents", {
                    method: "GET",
                    headers: {
                        "Authorization": `Bearer ${token}`
                    }
                });

                if (!response.ok) {
                    throw new Error("Error al obtener los documentos");
                }

                const data = await response.json();				
                this.documents = data;
            } catch (error) {
                console.error(error.message);
            }
        },
        async deleteDocument(documentId) {
            const token = sessionStorage.getItem("token");

            try {
                const response = await fetch(`http://127.0.0.1:8080/documents/${documentId}`, {
                    method: "DELETE",
                    headers: {
                        "Authorization": `Bearer ${token}`,
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ documentID: documentId })
                });

                if (!response.ok) {
                    throw new Error("Error al eliminar el documento");
                }

                this.documents = this.documents.filter(document => document.id !== documentId);
            } catch (error) {
                console.error(error.message);
            }
		}
    }
};
</script>

<style lang="scss" scoped>
@use './FileReader.scss';
</style>