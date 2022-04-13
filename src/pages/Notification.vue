<template>
  <q-page class="relative-position">
   
    <q-scroll-area class="absolute full-width full-height">
      <q-separator
        class="divider"
        color="grey-2"
        size="10px"
      />
      
      <q-list separator>
        <transition-group
          appear
          enter-active-class="animated fadeIn slow"
          leave-active-class="animated fadeOut slow"
        >
          <q-item
            v-for="qweet in qweets"
            :key="qweet.id"
            class="qweet q-py-md"
          >
            <q-item-section avatar top>
              <q-avatar size="xl">
                <img src="https://cdn.quasar.dev/img/boy-avatar.png">
              </q-avatar>
            </q-item-section>

            <q-item-section>
              <q-item-label class="text-subtitle1">
                <strong>Fire</strong>
                <span class="text-grey-7">
                  #Fire
                  <br class="lt-md">&bull; 14 hours ago<!--{{ qweet.date | relativeDate }}-->
                </span>
              </q-item-label>
              <q-item-label class="qweet-content text-body1">{{ qweet.content }}</q-item-label>
              <div class="qweet-icons row justify-between q-mt-sm">
                <q-btn
                  color="primary"
                  icon="fas fa-envelope"
                  label="Delivered: 2000"
                  size="sm"
                  flat
                  round
                />
               <!-- <q-item-label caption dense>Delivered: 2000</q-item-label>-->
                 <q-btn
                  color="primary"
                  icon="fas fa-envelope-open"
                  size="sm"
                  label="Reads: 950"
                  flat
                  round
                />
                <q-btn
                  color="primary"
                  icon="fas fa-map-marker-alt"
                  size="sm"
                  label="Delivered Area"
                  flat
                  round
                  to="/Map"
                />
              </div>
            </q-item-section>
          </q-item>
        </transition-group>
      </q-list>
    </q-scroll-area>
  </q-page>
</template>

<script>
export default {
  name: 'Post',
  data() {
    return {
      newQweetContent: '',
      qweets: [
        {
           id: 'ID1',
           content: 'Fire is very hot.',
           date: 1611653238221,
           liked: false
         },
         {
           id: 'ID2',
           content: 'Fire is bad.',
           date: 1611653252444,
           liked: true
         },
      ]
      
    }
  },
  filters: {
    relativeDate(value) {
      return formatDistance(value, new Date())
    }
  },
  }

</script>

<style lang="sass">
.new-qweet
  textarea
    font-size: 19px
    line-height: 1.4 !important
.divider
  border-top: 1px solid
  border-bottom: 1px solid
  border-color: $grey-4
.qweet:not(:first-child)
  border-top: 1px solid rgba(0, 0, 0, 0.12)
.qweet-content
  white-space: pre-line
.qweet-icons
  margin-left: -5px
</style>
